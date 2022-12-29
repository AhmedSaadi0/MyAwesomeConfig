#!/bin/bash
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/hybrid/hybrid.conf & conky -c ~/.config/awesome/themes/conky/name &
# glava --desktop --force-mod=a_circle --request="setgeometry 560 92 800 900" &
glava --desktop --force-mod=bars --request="setgeometry 1360 -43 510 900"