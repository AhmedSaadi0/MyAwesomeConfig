#!/bin/bash
# changelevel

# Arbitrary but unique message tag
msgTag="السطوع"

# Query amixer for the current level and whether or not the speaker is muted
level="$(brightnessctl -d intel_backlight | grep 'Current brightness' | awk -F'(' '{ print $2 }' | awk -F'%' '{ print $1 }')"

# dunstify -a "changelevel" -u low -i display-brightness -h string:x-dunst-stack-tag:$msgTag -h int:value:"$level" "مستوى السطوع: ${level}%"

notify-send.py "السطوع" "$level/100" \
                         --hint string:image-path:display-brightness boolean:transient:true \
                                int:has-percentage:$level \
                         --replaces-process "brightness-popup"