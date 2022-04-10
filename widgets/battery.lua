local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")

-- create battery widgets components
local baticon = wibox.widget.textbox()
baticon.font = beautiful.iconfont

local batperc = wibox.widget.textbox()
batperc.font = beautiful.uifont

local charging =
    wibox.widget {
    text = "",
    font = beautiful.iconfont,
    widget = wibox.widget.textbox
}

local warning =
    wibox.widget {
    text = "",
    font = beautiful.iconfont,
    widget = wibox.widget.textbox
}

-- battery warning not visible by default
warning.visible = false

-- update icons and percentage
function sb_battery()
    --  if battery widget is not visible or correctly showing replace BA* in a scripts below with (BAT1, BAT0 whatever you have.)
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/power_supply/BA*/capacity",
        function(stdout)
            local battery = tonumber(stdout)
            awful.spawn.easy_async_with_shell(
                "cat /sys/class/power_supply/BA*/status",
                function(out)
                    if string.match(out, "Charging") then
                        charging.visible = true
                    else
                        charging.visible = false
                    end
                    batperc.text = tonumber(battery) .. "%"
                    if battery <= 10 then
                        baticon.markup = "<span foreground = '" .. beautiful.red .. "'></span>"
                        if charging.visible then
                            warning.visible = false
                        else
                            warning.visible = true
                        end
                    elseif battery <= 15 then
                        baticon.markup = "<span foreground = '" .. beautiful.red .. "'></span>"
                        if charging.visible then
                            warning.visible = false
                        else
                            warning.visible = true
                        end
                    elseif battery <= 20 then
                        baticon.markup = "<span foreground = '" .. beautiful.red .. "'></span>"
                    elseif battery <= 30 then
                        baticon.text = ""
                    elseif battery <= 50 then
                        baticon.text = ""
                    elseif battery <= 70 then
                        baticon.text = ""
                    elseif battery <= 80 then
                        baticon.text = ""
                    elseif battery <= 90 then
                        baticon.text = ""
                    elseif battery <= 100 then
                        baticon.text = ""
                    end
                end
            )
        end
    )
end

sb_battery()

-- return widget
return wibox.widget {
    wibox.widget {
        baticon,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    wibox.widget {
        batperc,
        fg = beautiful.white,
        widget = wibox.container.background
    },
    wibox.widget {
        charging,
        fg = beautiful.blue,
        widget = wibox.container.background
    },
    wibox.widget {
        warning,
        fg = beautiful.red,
        widget = wibox.container.background
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal
}
