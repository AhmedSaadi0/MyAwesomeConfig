#!/bin/bash
killall conky & sleep 5 ; LC_ALL=C conky -c ~/.config/awesome/themes/conky/hybrid/hybrid.conf & conky -c ~/.config/awesome/themes/conky/name &