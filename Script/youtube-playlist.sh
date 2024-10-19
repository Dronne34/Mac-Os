#!/bin/bash

# Check if a playlist URL is provided
if [ -z "$1" ]; then
    echo "Usage: ./youtube-playlist.sh <playlist_url>"
    exit 1
fi

# Use yt-dlp to extract all video URLs from the playlist, while suppressing warnings
video_urls=$(yt-dlp --quiet --no-warnings --flat-playlist --get-url "$1")

# Play each video URL one by one in MPV
echo "$video_urls" | while read -r url; do
    mpv --no-terminal --quiet "$url" > /dev/null 2>&1
done
