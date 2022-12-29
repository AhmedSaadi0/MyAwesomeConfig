#!/bin/bash
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/vision/cosmic/conkyrc & 
glava --desktop --force-mod=cosmic --request="setgeometry 676 91 510 900"