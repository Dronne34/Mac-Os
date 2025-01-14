
#!/bin/bash
IFS=$'\t' read album artist title \
  <<< "$(mpc --format="%album%\t%artist%\t%title%")"

alerter -timeout 6 -title "$title" -subtitle "$album" -message "$artist"  -sender io.mpv