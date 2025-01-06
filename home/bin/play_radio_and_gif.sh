#!/bin/bash

# Redă radio-ul cu mpv
mpv http://usa9.fastcast4u.com/proxy/jamz?mp=/1 &

# Salvează PID-ul mpv
mpv_pid=$!

# Redă GIF-ul pe repetare cu ffplay, ascunzând linia de status
ffplay -hide_banner -loglevel quiet -loop 0 https://media.tenor.com/1VEnfKkMGikAAAAd/lofi-girl-music.gif

# Când ffplay se oprește, închide mpv
if ! ps -p $mpv_pid > /dev/null; then
    echo "MPV este deja închis."
else
    kill $mpv_pid
    echo "MPV a fost închis după ce ffplay s-a oprit."
fi


