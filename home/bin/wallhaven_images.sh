#!/bin/bash

# Check if jq and curl are installed
if ! command -v jq &>/dev/null || ! command -v curl &>/dev/null; then
    echo "This script requires jq and curl to be installed."
    exit 1
fi

# Create a folder to save images
mkdir -p wallhaven_images

# Wallhaven search URL with the given parameters
BASE_URL="https://wallhaven.cc/api/v1/search"

# Define the number of pages you want to download (3 pages)
NUM_PAGES=1

# Maximum image size (in bytes), which is 3 MB
MAX_SIZE=3145728

# Function to download images from a page
download_images_from_page() {
    local page=$1
    local url="$BASE_URL?page=$page&q=id%3A1713&categories=110&purity=100&atleast=1920x1080&sorting=relevance&order=desc&ai_art_filter=1"

    echo "Fetching page $page with tag '1713', category '110', resolution '1920x1080', sorting 'relevance'..."

    # Fetch JSON data from Wallhaven API
    response=$(curl -s "$url")

    # Check if response contains data
    if echo "$response" | jq -e '.data | length > 0' &>/dev/null; then
        # Extract image URLs from the JSON response
        image_urls=$(echo "$response" | jq -r '.data[].path')

        # Download each image, but only if its size is <= 3MB
        for image_url in $image_urls; do
            # Get the image size using curl and the Content-Length header
            image_size=$(curl -sI "$image_url" | grep -i "Content-Length" | awk '{print $2}' | tr -d '\r')

            # Check if the image size is smaller than or equal to 3 MB
            if [ "$image_size" -le "$MAX_SIZE" ]; then
                echo "Downloading image: $image_url (Size: ${image_size} bytes)"
                wget -q "$image_url" -P wallhaven_images
            else
                echo "Skipping image (too large): $image_url (Size: ${image_size} bytes)"
            fi
        done
    else
        echo "No images found on page $page. Skipping..."
    fi
}

# Loop through the first NUM_PAGES
for ((page=1; page<=NUM_PAGES; page++)); do
    download_images_from_page $page
done

echo "Download complete. All images are saved in the 'wallhaven_images' folder."
