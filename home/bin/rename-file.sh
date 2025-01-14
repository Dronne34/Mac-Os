#!/bin/bash

# Directory to process
# DIR="Pictures/pin"  # Change this if you want a specific directory

# Go to the directory
# cd "$DIR" || exit

# Counter for numbering
counter=1

# Loop over all .jpg files
for file in *.jpg *.png; do
    # Check if the file exists (in case there are no .jpg files)
    if [ -e "$file" ]; then
        # Generate new filename with padded number (e.g., image_001.jpg)
        new_name=$(printf "image_%03d.jpg" "$counter")
        mv "$file" "$new_name"
        echo "Renamed: $file -> $new_name"
        ((counter++))
    fi
done
