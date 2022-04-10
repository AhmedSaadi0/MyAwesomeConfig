local awful = require("awful")

-- Startup
awful.spawn.with_shell("xrandr --output eDP-1")
awful.spawn.with_shell("xfce4-power-manager")
awful.spawn.with_shell("picom -b --experimental-backends --dbus --config ~/.config/awesome/picom/sharp_shado.conf")
awful.spawn.with_shell(
    [[
    xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
    "awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
    ]]
)
awful.spawn.with_shell("/usr/lib/polkit-kde-authentication-agent-1")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell('setxkbmap -layout "us,ar" -option "grp:win_space_toggle"')
awful.spawn.with_shell("xrandr --output HDMI-1-0 --mode 1440x900 --rate 61 --noprimary --left-of eDP-1")
awful.spawn.with_shell("nitrogen --restore")
