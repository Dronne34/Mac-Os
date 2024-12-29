#!/bin/bash

# Check if yt-dlp is installed
if ! command -v yt-dlp &>/dev/null; then
    echo "Error: yt-dlp is not installed. Please install it first."
    exit 1
fi

# Prompt user for download folder or use default
read -p "Enter download folder path (default: /Users/ciprian/youtube): " input_folder
DOWNLOAD_FOLDER="${input_folder:-/Users/ciprian/youtube}"

# Create download folder if it doesn't exist
mkdir -p "$DOWNLOAD_FOLDER"

# Prompt user for the songs list file
read -p "Enter the path to the list of songs file (default: songs.txt): " input_file
SONGS_FILE="${input_file:-songs.txt}"

# Check if the file exists
if [[ ! -f "$SONGS_FILE" ]]; then
    echo "Error: File '$SONGS_FILE' not found."
    exit 1
fi

# Log file for download status
LOG_FILE="$DOWNLOAD_FOLDER/download_log.txt"
echo "Download log: $LOG_FILE"

# Loop through each song in the list file
while IFS= read -r song; do
    # Skip empty lines
    [[ -z "$song" ]] && continue

    # Generate the output file path based on song title
    OUTPUT_FILE="$DOWNLOAD_FOLDER/$(echo "$song" | sed 's/[^a-zA-Z0-9]/_/g').mp3"
    
    # Check if the file already exists
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "Skipping (already exists): $song" | tee -a "$LOG_FILE"
        continue
    fi

    echo "Searching and downloading: $song"
    
    # Search for the song on YouTube and download it as MP3
    if yt-dlp --extract-audio -f bestaudio --audio-format mp3 --embed-thumbnail --prefer-ffmpeg \
        -o "$DOWNLOAD_FOLDER/%(title)s.%(ext)s" "ytsearch:$song"; then
        echo "Downloaded: $song" | tee -a "$LOG_FILE"
    else
        echo "Failed to download: $song" | tee -a "$LOG_FILE"
    fi
done < "$SONGS_FILE"

echo "Download complete! Check the log file for details: $LOG_FILE"
