-- thumbfast.lua
--
-- High-performance on-the-fly thumbnailer
--
-- Built for easy integration in third-party UIs.

local options = {
    -- Socket path (leave empty for auto)
    socket = "",

    -- Thumbnail path (leave empty for auto)
    thumbnail = "",

    -- Maximum thumbnail size in pixels (scaled down to fit)
    -- Values are scaled when hidpi is enabled
    max_height = 200,
    max_width = 200,

    -- Overlay id
    overlay_id = 42,

    -- Spawn thumbnailer on file load for faster initial thumbnails
    spawn_first = false,

    -- Enable on network playback
    network = false,

    -- Enable on audio playback
    audio = false,

    -- Enable hardware decoding
    hwdec = false,

    -- Windows only: use native Windows API to write to pipe (requires LuaJIT)
    direct_io = false
}

mp.utils = require "mp.utils"
mp.options = require "mp.options"
mp.options.read_options(options, "thumbfast")

local pre_0_30_0 = mp.command_native_async == nil

function subprocess(args, async, callback)
    callback = callback or function() end

    if not pre_0_30_0 then
        if async then
            return mp.command_native_async({name = "subprocess", playback_only = true, args = args}, callback)
        else
            return mp.command_native({name = "subprocess", playback_only = false, capture_stdout = true, args = args})
        end
    else
        if async then
            return mp.utils.subprocess_detached({args = args}, callback)
        else
            return mp.utils.subprocess({args = args})
        end
    end
end

local winapi = {}
if options.direct_io then
    local ffi_loaded, ffi = pcall(require, "ffi")
    if ffi_loaded then
        winapi = {
            ffi = ffi,
            C = ffi.C,
            bit = require("bit"),
            socket_wc = "",

            -- WinAPI constants
            CP_UTF8 = 65001,
            GENERIC_WRITE = 0x40000000,
            OPEN_EXISTING = 3,
            FILE_FLAG_WRITE_THROUGH = 0x80000000,
            FILE_FLAG_NO_BUFFERING = 0x20000000,
            PIPE_NOWAIT = ffi.new("unsigned long[1]", 0x00000001),

            INVALID_HANDLE_VALUE = ffi.cast("void*", -1),

            -- don't care about how many bytes WriteFile wrote, so allocate something to store the result once
            _lpNumberOfBytesWritten = ffi.new("unsigned long[1]"),
        }
        -- cache flags used in run() to avoid bor() call
        winapi._createfile_pipe_flags = winapi.bit.bor(winapi.FILE_FLAG_WRITE_THROUGH, winapi.FILE_FLAG_NO_BUFFERING)

        ffi.cdef[[
            void* __stdcall CreateFileW(const wchar_t *lpFileName, unsigned long dwDesiredAccess, unsigned long dwShareMode, void *lpSecurityAttributes, unsigned long dwCreationDisposition, unsigned long dwFlagsAndAttributes, void *hTemplateFile);
            bool __stdcall WriteFile(void *hFile, const void *lpBuffer, unsigned long nNumberOfBytesToWrite, unsigned long *lpNumberOfBytesWritten, void *lpOverlapped);
            bool __stdcall CloseHandle(void *hObject);
            bool __stdcall SetNamedPipeHandleState(void *hNamedPipe, unsigned long *lpMode, unsigned long *lpMaxCollectionCount, unsigned long *lpCollectDataTimeout);
            int __stdcall MultiByteToWideChar(unsigned int CodePage, unsigned long dwFlags, const char *lpMultiByteStr, int cbMultiByte, wchar_t *lpWideCharStr, int cchWideChar);
        ]]

        winapi.MultiByteToWideChar = function(MultiByteStr)
            if MultiByteStr then
                local utf16_len = winapi.C.MultiByteToWideChar(winapi.CP_UTF8, 0, MultiByteStr, -1, nil, 0)
                if utf16_len > 0 then
                    local utf16_str = winapi.ffi.new("wchar_t[?]", utf16_len)
                    if winapi.C.MultiByteToWideChar(winapi.CP_UTF8, 0, MultiByteStr, -1, utf16_str, utf16_len) > 0 then
                        return utf16_str
                    end
                end
            end
            return ""
        end

    else
        options.direct_io = false
    end
end

local spawned = false
local network = false
local disabled = false
local spawn_waiting = false

local x = nil
local y = nil
local last_x = x
local last_y = y

local last_seek_time = nil

local effective_w = options.max_width
local effective_h = options.max_height
local real_w = nil
local real_h = nil
local last_real_w = nil
local last_real_h = nil

local script_name = nil

local show_thumbnail = false

local filters_reset = {["lavfi-crop"]=true, crop=true}
local filters_runtime = {hflip=true, vflip=true}
local filters_all = filters_runtime
for k,v in pairs(filters_reset) do filters_all[k] = v end

local last_vf_reset = ""
local last_vf_runtime = ""

local last_rotate = 0

local par = ""
local last_par = ""

local last_has_vid = 0
local has_vid = 0

local file_timer = nil
local file_check_period = 1/60
local first_file = false

local function debounce(func, wait)
    func = type(func) == "function" and func or function() end
    wait = type(wait) == "number" and wait / 1000 or 0

    local timer = nil
    local timer_end = function ()
        timer:kill()
        timer = nil
        func()
    end

    return function ()
        if timer then
            timer:kill()
        end
        timer = mp.add_timeout(wait, timer_end)
    end
end

local function on_idle()
    if mp.get_opt("auto-profiles") == "no" then
        return
    end

    -- When events and property notifications stop, re-evaluate all dirty profiles.
    if have_dirty_profiles then
        for _, profile in ipairs(profiles) do
            if profile.dirty then
                evaluate(profile)
            end
        end
    end
    have_dirty_profiles = false
end

mp.register_idle(on_idle)

local evil_meta_magic = {
    __index = function(table, key)
        -- interpret everything as property, unless it already exists as
        -- a non-nil global value
        local v = _G[key]
        if type(v) ~= "nil" then
            return v
        end
        -- Lua identifiers can't contain "-", so in order to match with mpv
        -- property conventions, replace "_" to "-"
        key = string.gsub(key, "_", "-")
        -- Normally, we use the cached value only (to reduce CPU usage I guess?)
        if not watched_properties[key] then
            watched_properties[key] = true
            mp.observe_property(key, "native", on_property_change)
            cached_properties[key] = mp.get_property_native(key)
        end
        -- The first time the property is read we need add it to the
        -- properties_to_profiles table, which will be used to mark the profile
        -- dirty if a property referenced by it changes.
        if current_profile then
            local map = properties_to_profiles[key]
            if not map then
                map = {}
                properties_to_profiles[key] = map
            end
            map[current_profile] = true
        end
        return cached_properties[key]
    end,
}

local evil_magic = {}
setmetatable(evil_magic, evil_meta_magic)

local function compile_cond(name, s)
    chunk, err = loadstring("return " .. s, "profile " .. name .. " condition")
    if not chunk then
        msg.error("Profile '" .. name .. "' condition: " .. err)
        return function() return false end
    end
    return chunk
end

for i, v in ipairs(mp.get_property_native("profile-list")) do
    local desc = v["profile-desc"]
    if desc and desc:sub(1, 5) == "cond:" then
        local profile = {
            name = v.name,
            cond = compile_cond(v.name, desc:sub(6)),
            properties = {},
            status = nil,
            dirty = true, -- need re-evaluate
        }
        profiles[#profiles + 1] = profile
        have_dirty_profiles = true
    end
end

-- these definitions are for use by the condition expressions

p = evil_magic

function get(property_name, default)
    local val = p[property_name]
    if val == nil then
        val = default
    end
    return val
end

-- re-evaluate all profiles immediately
on_idle()