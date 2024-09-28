#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="/Users/ciprian/Pictures"

# Get a random wallpaper from the folder
RANDOM_WALLPAPER=$(ls "$WALLPAPER_DIR" | sort -R | head -1)

# Full path to the random wallpaper
RANDOM_WALLPAPER_PATH="$WALLPAPER_DIR/$RANDOM_WALLPAPER"

# AppleScript to change the wallpaper
osascript <<EOD
tell application "Finder"
    set desktop picture to POSIX file "$RANDOM_WALLPAPER_PATH"
end tell
EOD