#!/bin/sh

menu() {
  printf "1.  📺 Pro TV HD – RDS Live\n"
  printf "2.  🏛️ Antena 1 HD – RDS Live\n"
  printf "3.  🎬 HBO HD – RDS Live\n"
  printf "4.  🧠 SkyShowTime 1 HD – RDS Live\n"
  printf "5.  🔴 AMC HD – RDS Live\n"
  printf "6.  🔔 Film Now HD – RDS Live\n"
  printf "7.  🌇 TV 1000 – RDS Live\n"
  printf "8.  🎥 Film Cafe – RDS Live\n"
  printf "9.  📩 Warner TV – RDS Live\n"
  printf "10. 🍏 Atomic – RDS Live\n"
}


main() {
  choice=$(menu | choose -b ff79c6 -w 48 -n 11 -s 25 2>/dev/null | cut -d. -f1)

  case $choice in
  1)
    # open -n "/Applications/Brave Browser.app" "https://duckduckgo.com/"
    open -n "/Applications/Brave Browser.app" "https://rds.live/pro-tv-hd-8/"
    break
    ;;
  2)
    open -n "/Applications/Brave Browser.app" "https://rds.live/antena-1-22/"
    break
    ;;
  3)
    open -n "/Applications/Brave Browser.app" "https://rds.live/hbo-hd-1/"
    break
    ;;
  4)
    open -n "/Applications/Brave Browser.app" "https://rds.live/skyshowtime-hd/"
    break
    ;;
  5)
    open -n "/Applications/Brave Browser.app" "https://rds.live/amc/"
    break
    ;;
  6)
    open -n "/Applications/Brave Browser.app" "https://rds.live/film-now-ro1/"
    break
    ;;
  7)
    open -n "/Applications/Brave Browser.app" "https://rds.live/tv-1000/"
    break
    ;;
  8)
    open -n "/Applications/Brave Browser.app" "https://rds.live/film-cafe/"
    break
    ;;
  9)
    open -n "/Applications/Brave Browser.app" "https://rds.live/warner-tv/"
    break
    ;;
  10)
    open -n "/Applications/Brave Browser.app" "https://rds.live/atomic/"
    break
    ;;

  esac
}

pkill -f "" || main
# pkill -f "Brave Browser" || main
