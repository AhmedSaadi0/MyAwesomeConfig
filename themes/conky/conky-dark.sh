#!/bin/bash
# killall conky & sleep 5 ; conky -c ~/.config/awesome/configuration/conky/hybrid/hybrid.conf & conky -c ~/.config/awesome/configuration/conky/name.lua & conky -c ~/.config/awesome/configuration/conky/pie_clock/conkyrc &
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/vision/dark/conkyrc
glava --desktop --force-mod=islamic --request="setgeometry 566 92 800 900"