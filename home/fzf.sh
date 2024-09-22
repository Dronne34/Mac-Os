
#!/bin/bash

# Get the current song information
current_song=$(osascript -e 'tell application "Spotify" to name of current track')
current_artist=$(osascript -e 'tell application "Spotify" to artist of current track')

# Display the notification
osascript -e "display notification \"$current_song\" with title \"$current_artist\" sound name \"Glass\""

