#!/bin/bash

# URL-ul de unde vom descărca conținutul HTML
url="https://www.cinemagia.ro/program-tv/post/amc/"

# Coduri de culoare
green='\033[0;32m'
yellow='\033[1;33m'
reset='\033[0m'

# Extrage orele
hours=$(curl -s "$url" | htmlq -t 'td.ora div')

# Extrage titlurile
titles=$(curl -s "$url" | htmlq -t 'td.event div.title a')

# Extrage descrierea filmului
descriptions=$(curl -s "$url" | htmlq -t 'td.event span.small')

# Extrage imagini (URL)
images=$(curl -s "$url" | htmlq -t 'td.event div.thumb img' | htmlq -t 'src')

# Combină datele manual și afișează ieșirea cu culori
IFS=$'\n'
hours_arr=($hours)
titles_arr=($titles)
descriptions_arr=($descriptions)
images_arr=($images)

# Lățimea coloanelor pentru aliniere verticală și mai mult spațiu între ele
hour_width=12      # Lățime pentru ora
title_width=45     # Lățime pentru titlu
description_width=60  # Lățime pentru descriere
# image_width=50     # Lățime pentru imagine

# Iterăm prin fiecare element
for i in $(seq 0 $((${#hours_arr[@]} - 1))); do
    hour="${hours_arr[$i]}"
    title="${titles_arr[$i]}"
    description="${descriptions_arr[$i]}"
    # image="${images_arr[$i]}"

    # Afișăm fiecare linie cu mai mult spațiu între coloane
    printf "$yellow%-*s$reset  %-*s  $green%-*s$reset  %-*s\n" \
        $hour_width "$hour" $title_width "$title" $description_width "$description"
done
