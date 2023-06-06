#!/bin/bash
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/vision/batman/conkyrc
glava --desktop --force-mod=a_batman --request="setgeometry 1275 503 510 100"
