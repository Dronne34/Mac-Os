#!/bin/bash

# URL of the YouTube video to play
VIDEO_URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"

# Get the direct video stream URL using yt-dlp without specifying a format
VIDEO_STREAM_URL=$(yt-dlp -g "$VIDEO_URL" 2>/dev/null)

# Check if we got a valid stream URL
if [[ -n "$VIDEO_STREAM_URL" ]]; then
  # Play the video using ffplay and suppress logs
  ffplay -loglevel quiet "$VIDEO_STREAM_URL" 2>/dev/null
else
  echo "Failed to retrieve video stream URL."
fi
