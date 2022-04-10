#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolume"

# Change the volume using alsa(might differ if you use pulseaudio)
amixer -c 0 set Master "$@" > /dev/null

VOLUME=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | tr -d "%")
MUTE=$(amixer sget Master | grep -o '\[off\]' | tail -n 1)

if [ "$VOLUME" -le 20 ]; then
    ICON=audio-volume-low
else if [ "$VOLUME" -le 60 ]; then
         ICON=audio-volume-medium
     else 
         ICON=audio-volume-high
     fi
fi
if [ "$MUTE" == "[off]" ]; then
    ICON=audio-volume-muted
fi 

NOTI_ID=$(notify-send.py "مستوى الصوت : " "$VOLUME/100" \
                         --hint string:image-path:$ICON boolean:transient:true \
                                int:has-percentage:$VOLUME \
                         --replaces-process "volume-popup")


# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"