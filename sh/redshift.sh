#!/bin/sh
if [ ! -z $(pgrep redshift) ];
then
    redshift -x && pkill redshift && killall redshift
    notify-send.py "وضع القراءة" "ايقاف وضع القراءة" --hint string:image-path:display-brightness boolean:transient:true --replaces-process "brightness-popup"
else
    redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
    notify-send.py "وضع القراءة" "تشغيل وضع القراءة" --hint string:image-path:display-brightness boolean:transient:true --replaces-process "brightness-popup"
fi
