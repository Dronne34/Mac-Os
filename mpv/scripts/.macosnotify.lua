-- macosnotify.lua
-- This script goes in .config/mpv/scripts and displays a Now Playing notification.
-- It's solely designed to be used with YouTube playlists, so it probably won't work for anything else.

function notify_current_track()
    local filename = mp.get_property_native("media-title")

    if not filename then return end

    local notif = ("osascript -e 'display notification \"%s\" with title \"Now Playing\"'"):format(filename)
    os.execute(notif)
end

mp.register_event("file-loaded", notify_current_track)
mp.observe_property("metadata", nil, notify_current_track)