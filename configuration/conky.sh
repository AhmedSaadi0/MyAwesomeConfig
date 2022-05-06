#!/bin/bash
killall conky & sleep 5 ; conky -c ~/.config/awesome/configuration/conky/hybrid/hybrid.conf & conky -c ~/.config/awesome/configuration/conky/name.lua & conky -c ~/.config/awesome/configuration/conky/pie_clock/conkyrc &
