#!/bin/sh

menu() {
  printf "1. 🖥️ Poweroff\n"
  printf "2. 🔒 Logout\n"
  printf "3. 🚶‍♂️ Sleep\n"
  printf "4. 🔄 Restart\n"
  printf "5. 🌐 Network Settings\n"
  printf "6. 🛠️ System Preferences\n"
  printf "7. 🌐 Wi-Fi Settings\n"
  printf "8. 🗑️ Trash\n"
}

main() {
  choice=$(menu | choose -b ff79c6 -w 48 -n 9 -s 25 2>/dev/null | cut -d. -f1)

  case $choice in
  1)
    # Power off
    osascript -e 'tell app "System Events" to shut down'
    break
    ;;
  2)
    # Logout
    osascript -e 'tell app "System Events" to log out'
    break
    ;;
  3)
    # Sleep
    pmset sleepnow
    break
    ;;
  4)
    # Restart
    osascript -e 'tell app "System Events" to restart'
    break
    ;;
  5)
    # Open Network Preferences
    open -n "/System/Library/PreferencePanes/Network.prefPane"
    break
    ;;
  6)
    # Open System Preferences
    open -n "/System/Applications/System Settings.app"
    break
    ;;
  7)
    # Open Wi-Fi Settings
    open -n "/System/Library/PreferencePanes/Network.prefPane"
    break
    ;;
  8)
    # Open Trash
    open ~/.Trash
    break
    ;;
  esac
}

main
