#!/bin/bash
# killall conky & sleep 5 ; conky -c ~/.config/awesome/configuration/conky/hybrid/hybrid.conf & conky -c ~/.config/awesome/configuration/conky/name.lua & conky -c ~/.config/awesome/configuration/conky/pie_clock/conkyrc &
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/hybrid-light/hybrid.conf &
# LC_ALL=C conky -c ~/.config/awesome/themes/conky/circular-analog-clock-light/circular-analog-clock
glava --desktop --force-mod=a_light --request="setgeometry 176 377 400 400"