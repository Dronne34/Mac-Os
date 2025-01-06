#!/bin/bash

# Path to the folder containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"  # Use $HOME to ensure the path is correct for any user

# Find all image files in the directory and select one randomly
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | gshuf -n 1)

# Check if a wallpaper was found
if [ -z "$RANDOM_WALLPAPER" ]; then
    echo "No wallpaper found in the directory."
    exit 1
fi

# Set the selected wallpaper using osascript to change the wallpaper
osascript -e "tell application \"System Events\" to set picture of desktop 1 to POSIX file \"$RANDOM_WALLPAPER\""

echo "Wallpaper set to: $RANDOM_WALLPAPER"
