local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local json = require("library.json")

local config_dir = gears.filesystem.get_configuration_dir()

local prayer = ""

local function factory(args)
    local city = args.city or beautiful.city or "sanaa"
    local country = args.country or beautiful.country or "yemen"
    local method = args.method or beautiful.method or 3

    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local header_bg = args.header_bg or beautiful.header_bg

    local bg = args.bg or beautiful.bg_normal

    local widget_bg = args.widget_bg or beautiful.widget_bg
    local widget_fg = args.widget_fg or beautiful.fg_normal

    local border_width = args.border_width or beautiful.control_border_width
    local border_color = args.border_color or beautiful.border_focus

    local whole_bg_color = beautiful.weather_color_whole_color or beautiful.transparent

    local popup_shape = args.popup_shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local widget_shape = args.widget_shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local number_text_widget =
        wibox.widget {
        text = "",
        screen = "primary",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local icon =
        wibox.widget {
        markup = helpers.colorize_text("", beautiful.weather_icon_fg_color, icon_font),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local panal_widget =
        wibox.widget {
        helpers.set_widget_block {
            widget = {
                layout = wibox.layout.fixed.horizontal,
                helpers.set_widget_block {
                    widget = number_text_widget,
                    bg = beautiful.weather_color,
                    fg = beautiful.weather_text_color,
                    shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                    left = 8,
                    right = 5
                },
                helpers.set_widget_block {
                    widget = icon,
                    bg = beautiful.weather_icon_bg_color,
                    shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                    right = 8,
                    left = 4
                }
            },
            bg = whole_bg_color,
            id = "widget_id",
            font = beautiful.iconfont,
            shape = helpers.rrect(beautiful.widgets_corner_radius)
        },
        layout = wibox.layout.fixed.horizontal
    }

    --------------------
    --  POP UP Widget --
    --------------------
    local header =
        wibox.widget {
        text = "اوقات الصلوات",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.fixed.vertical,
        visible = false,
        {
            {
                {
                    {
                        header,
                        left = dpi(12),
                        top = dpi(15),
                        bottom = dpi(15),
                        right = dpi(12),
                        widget = wibox.container.margin
                    },
                    bg = header_bg,
                    widget = wibox.container.background
                },
                helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.fixed.horizontal,
                        widget_1,
                        widget_2,
                        widget_3,
                        widget_4
                    },
                    top = dpi(12),
                    bottom = dpi(12),
                    left = dpi(12),
                    -- right = dpi(12),
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.fixed.horizontal,
                        widget_5,
                        widget_6,
                        widget_7,
                        widget_8
                    },
                    -- top = dpi(12),
                    bottom = dpi(12),
                    left = dpi(12),
                    -- right = dpi(12),
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.fixed.horizontal,
                        widget_9,
                        widget_10,
                        widget_11,
                        widget_12
                    },
                    -- top = dpi(12),
                    bottom = dpi(12),
                    left = dpi(12),
                    -- right = dpi(12),
                    bg = beautiful.transparent
                },
                layout = wibox.layout.fixed.vertical
            },
            bg = bg,
            -- shape = shape,
            widget = wibox.container.background
        }
    }

    local popup =
        awful.popup {
        ontop = true,
        visible = false,
        id = "widget_4",
        shape = popup_shape,
        border_width = border_width,
        border_color = border_color,
        -- maximum_width = 600,
        offset = {y = 10, x = 100},
        widget = detailed_widget
    }

    -- watch(
    --     "curl 'https://api.aladhan.com/v1/timingsByCity?city=" ..
    --         city .. "&country=" .. country .. "&method=" .. method .. "'",
    --     3600,
    --     function(_, stdout)
    --         if stdout == "" then
    --             number_text_widget.text = "غير متوفرة حاليا"
    --             return
    --         end

    --         local json_object = json.parse(stdout)

    --         local current_time = os.date("%H:%M")

    --         if current_time > json_object.data.timings.Isha or current_time <= json_object.data.timings.Fajr then
    --             number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
    --         elseif current_time > json_object.data.timings.Maghrib then
    --             local h, m = json_object.data.timings.Isha:match("^(%d%d):(%d%d)$")
    --             h = (h - 12)
    --             number_text_widget.text = "العشاء (0" .. h .. ":" .. m .. ")"
    --         elseif current_time > json_object.data.timings.Asr then
    --             local h, m = json_object.data.timings.Maghrib:match("^(%d%d):(%d%d)$")
    --             h = (h - 12)
    --             number_text_widget.text = "المغرب (0" .. h .. ":" .. m .. ")"
    --         elseif current_time > json_object.data.timings.Dhuhr then
    --             local h, m = json_object.data.timings.Asr:match("^(%d%d):(%d%d)$")
    --             h = (h - 12)
    --             number_text_widget.text = "العصر (0" .. h .. ":" .. m .. ")"
    --         elseif current_time > json_object.data.timings.Fajr then
    --             number_text_widget.text = "الظهر (" .. json_object.data.timings.Dhuhr .. ")"
    --         end
    --     end
    -- )

    function set_timer(time)
        gears.timer {
            timeout = time,
            call_now = true,
            autostart = true,
            callback = function()
                -- You should read it from `/sys/class/power_supply/` (on Linux)
                -- instead of spawning a shell. This is only an example.
                number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
            end
        }
    end

    local prayer_timer =
        gears.timer {
        timeout = 360,
        call_now = false,
        autostart = false,
        callback = function()
            play_athan_sound()
            calculate_prayer_times()
        end
    }

    function play_athan_sound()
        awful.spawn.with_shell("notify-send -a 'الاذان' 'حان الان وقت صلاة " .. prayer .. "'")
        local sound = beautiful.notification_sound or "widget/prayer-times/sounds/notification.ogg"
        awful.spawn.with_shell("paplay " .. config_dir .. sound, false)
    end

    function get_difftime(paryer_hour, paryer_minute)
        local prayer_day = tonumber(os.date("%d"))

        local hour_now = os.date("%H")

        if tonumber(hour_now) > tonumber(paryer_hour) then
            prayer_day = tonumber(prayer_day) + 1
        end

        local prayer_time =
            os.time {
            year = os.date("%Y"),
            month = os.date("%m"),
            day = prayer_day,
            hour = paryer_hour,
            min = paryer_minute
        }

        return os.difftime(prayer_time, os.time())
    end

    function calculate_prayer_times()
        awful.spawn.easy_async_with_shell(
            "curl 'https://api.aladhan.com/v1/timingsByCity?city=" ..
                city .. "&country=" .. country .. "&method=" .. method .. "'",
            function(stdout)
                if stdout == "" then
                    number_text_widget.text = "غير متوفرة حاليا"
                    return
                end

                prayer_timer:stop()

                local json_object = json.parse(stdout)

                local current_time = os.date("%H:%M")

                local h, m = "", ""

                -- Set name of prayer in panal
                if current_time >= json_object.data.timings.Isha and current_time < json_object.data.timings.Fajr then
                    prayer = "الفجر"
                    number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
                    h, m = json_object.data.timings.Fajr:match("^(%d%d):(%d%d)$")
                elseif current_time >= json_object.data.timings.Maghrib and current_time < json_object.data.timings.Isha then
                    prayer = "العشاء"
                    h, m = json_object.data.timings.Isha:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "العشاء (0" .. (h - 12) .. ":" .. m .. ")"
                elseif current_time >= json_object.data.timings.Asr and current_time < json_object.data.timings.Maghrib then
                    prayer = "المغرب"
                    h, m = json_object.data.timings.Maghrib:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "المغرب (0" .. (h - 12) .. ":" .. m .. ")"
                elseif current_time >= json_object.data.timings.Dhuhr and current_time < json_object.data.timings.Asr then
                    prayer = "العصر"
                    h, m = json_object.data.timings.Asr:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "العصر (0" .. (h - 12) .. ":" .. m .. ")"
                elseif current_time >= json_object.data.timings.Fajr and current_time < json_object.data.timings.Dhuhr then
                    prayer = "الظهر"
                    number_text_widget.text = "الظهر (" .. json_object.data.timings.Dhuhr .. ")"
                    h, m = json_object.data.timings.Dhuhr:match("^(%d%d):(%d%d)$")
                end

                -- Set athan timer
                prayer_timer.timeout = get_difftime(h, m)
                prayer_timer:start()

            end
        )
    end

    calculate_prayer_times()

    number_text_widget:connect_signal(
        "button::press",
        function()
            -- if popup.visible then
            --     popup.visible = not popup.visible
            -- else
            --     popup:move_next_to(mouse.current_widget_geometry)
            -- end
        end
    )

    return panal_widget
end

return factory
