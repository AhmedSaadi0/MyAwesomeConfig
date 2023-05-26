local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local json = require("library.json")
local naughty = require("naughty")

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

    local prayer_times_inner_text_color = args.prayer_times_inner_text_color or beautiful.prayer_times_inner_text_color
    local widget_fg = args.widget_fg or beautiful.fg_normal

    local border_width = args.border_width or beautiful.control_border_width
    local border_color = args.border_color or beautiful.border_focus

    local whole_bg_color = beautiful.prayer_times_color_whole_color or beautiful.transparent

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
        markup = helpers.colorize_text("", beautiful.prayer_times_icon_fg_color, icon_font),
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
                    bg = beautiful.prayer_times_color,
                    fg = beautiful.prayer_times_text_color,
                    shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                    left = 8,
                    right = 5
                },
                helpers.set_widget_block {
                    widget = icon,
                    bg = beautiful.prayer_times_icon_bg_color,
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
        helpers.add_text_icon_widget {
        text = "اوقات الصلوات",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    -- local hijri_date =
    --     wibox.widget {
    --     text = "",
    --     font = text_font,
    --     align = "center",
    --     valign = "center",
    --     widget = wibox.widget.textbox
    -- }

    local fajr =
        helpers.add_text_icon_widget {
        text = "صلاة الفجر",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    local dhuhr =
        helpers.add_text_icon_widget {
        text = "صلاة الظهر",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    local asr =
        helpers.add_text_icon_widget {
        text = "صلاة العصر",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    local maghrib =
        helpers.add_text_icon_widget {
        text = "صلاة المغرب",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    local isha =
        helpers.add_text_icon_widget {
        text = "صلاة العشاء",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        widget = wibox.widget.textbox
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.fixed.vertical,
        {
            {
                {
                    {
                        header,
                        left = dpi(25),
                        right = dpi(25),
                        widget = wibox.container.margin
                    },
                    bg = header_bg,
                    widget = wibox.container.background
                },
                helpers.set_widget_block {
                    widget = fajr,
                    left = dpi(25),
                    right = dpi(20),
                    id = "fajr_widget",
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = dhuhr,
                    left = dpi(25),
                    right = dpi(20),
                    id = "dhuhr_widget",
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = asr,
                    left = dpi(25),
                    right = dpi(20),
                    id = "asr_widget",
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = maghrib,
                    left = dpi(25),
                    right = dpi(20),
                    id = "maghrib_widget",
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = isha,
                    left = dpi(25),
                    right = dpi(20),
                    id = "isha_widget",
                    bg = beautiful.transparent
                },
                layout = wibox.layout.fixed.vertical
            },
            bg = bg,
            -- shape = shape,
            forced_width = 180,
            widget = wibox.container.background
        }
    }

    local popup =
        awful.popup {
        ontop = true,
        visible = false,
        id = "prayer_pop_up",
        shape = popup_shape,
        border_width = border_width,
        border_color = border_color,
        offset = {y = 10, x = 100},
        widget = detailed_widget
    }

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

    local recalculate_timer =
        gears.timer {
        timeout = 1000,
        call_now = false,
        autostart = false,
        callback = function()
            calculate_prayer_times()
        end
    }

    local athan_timer =
        gears.timer {
        call_now = false,
        autostart = false,
        callback = function()
            play_athan_sound()
            number_text_widget.text = "صلاة " .. prayer .. " الان"
        end
    }

    function play_athan_sound()
        athan_timer:stop()
        recalculate_timer:start()
        naughty.notification(
            {
                icon = config_dir .. "widget/prayer-times/mosque.png",
                app_name = "الاذان",
                title = "صلاة " .. prayer,
                message = "حان الان موعد صلاة " .. prayer,
                urgency = "normal"
            }
        )
        local sound = beautiful.athan_sound or "widget/prayer-times/sounds/notification.ogg"
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

    function set_detailed_time(fajr_time, dhuhr_time, asr_time, maghrib_time, isha_time)
        fajr:get_children_by_id("icon_id")[1].text = helpers.to_12(fajr_time) -- "صلاة الفجر " .. fajr_time
        dhuhr:get_children_by_id("icon_id")[1].text = helpers.to_12(dhuhr_time) -- "صلاة الظهر " .. dhuhr_time
        asr:get_children_by_id("icon_id")[1].text = helpers.to_12(asr_time) -- "صلاة العصر " .. asr_time
        maghrib:get_children_by_id("icon_id")[1].text = helpers.to_12(maghrib_time) -- "صلاة المغرب " .. maghrib_time
        isha:get_children_by_id("icon_id")[1].text = helpers.to_12(isha_time) -- "صلاة العشاء " .. isha_time
    end

    function calculate_prayer_times()
        awful.spawn.easy_async_with_shell(
            "curl 'https://api.aladhan.com/v1/timingsByCity/" ..
                os.date("%d-%m-%Y") .. "?city=" .. city .. "&country=" .. country .. "&method=" .. method .. "'",
            function(stdout)
                if stdout == "" then
                    number_text_widget.text = "غير متوفرة حاليا"
                    athan_timer:stop()
                    recalculate_timer:stop()
                    recalculate_timer.timeout = 60
                    recalculate_timer:start()
                    return
                end

                athan_timer:stop()
                recalculate_timer:stop()

                local json_object = json.parse(stdout)

                local current_time = os.date("%H:%M")

                local h, m = "", ""

                detailed_widget:get_children_by_id("fajr_widget")[1].bg = beautiful.transparent
                detailed_widget:get_children_by_id("fajr_widget")[1].fg = beautiful.widget_fg

                detailed_widget:get_children_by_id("dhuhr_widget")[1].bg = beautiful.transparent
                detailed_widget:get_children_by_id("dhuhr_widget")[1].fg = beautiful.widget_fg

                detailed_widget:get_children_by_id("asr_widget")[1].bg = beautiful.transparent
                detailed_widget:get_children_by_id("asr_widget")[1].fg = beautiful.widget_fg

                detailed_widget:get_children_by_id("maghrib_widget")[1].bg = beautiful.transparent
                detailed_widget:get_children_by_id("maghrib_widget")[1].fg = beautiful.widget_fg

                detailed_widget:get_children_by_id("isha_widget")[1].bg = beautiful.transparent
                detailed_widget:get_children_by_id("isha_widget")[1].fg = beautiful.widget_fg

                -- Set name of prayer in panal
                if current_time >= json_object.data.timings.Isha or current_time < json_object.data.timings.Fajr then
                    prayer = "الفجر"
                    number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
                    h, m = json_object.data.timings.Fajr:match("^(%d%d):(%d%d)$")

                    detailed_widget:get_children_by_id("fajr_widget")[1].bg = beautiful.prayer_times_inner_bg_color or beautiful.prayer_times_icon_bg_color
                    detailed_widget:get_children_by_id("fajr_widget")[1].fg = beautiful.prayer_times_inner_text_color
                elseif current_time >= json_object.data.timings.Maghrib and current_time < json_object.data.timings.Isha then
                    prayer = "العشاء"
                    h, m = json_object.data.timings.Isha:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "العشاء (0" .. (h - 12) .. ":" .. m .. ")"

                    detailed_widget:get_children_by_id("isha_widget")[1].bg = beautiful.prayer_times_inner_bg_color or beautiful.prayer_times_icon_bg_color
                    detailed_widget:get_children_by_id("isha_widget")[1].fg = beautiful.prayer_times_inner_text_color
                elseif current_time >= json_object.data.timings.Asr and current_time < json_object.data.timings.Maghrib then
                    prayer = "المغرب"
                    h, m = json_object.data.timings.Maghrib:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "المغرب (0" .. (h - 12) .. ":" .. m .. ")"

                    detailed_widget:get_children_by_id("maghrib_widget")[1].bg = beautiful.prayer_times_inner_bg_color or beautiful.prayer_times_icon_bg_color
                    detailed_widget:get_children_by_id("maghrib_widget")[1].fg = beautiful.prayer_times_inner_text_color
                elseif current_time >= json_object.data.timings.Dhuhr and current_time < json_object.data.timings.Asr then
                    prayer = "العصر"
                    h, m = json_object.data.timings.Asr:match("^(%d%d):(%d%d)$")
                    number_text_widget.text = "العصر (0" .. (h - 12) .. ":" .. m .. ")"

                    detailed_widget:get_children_by_id("asr_widget")[1].bg = beautiful.prayer_times_inner_bg_color or beautiful.prayer_times_icon_bg_color
                    detailed_widget:get_children_by_id("asr_widget")[1].fg = beautiful.prayer_times_inner_text_color
                elseif current_time >= json_object.data.timings.Fajr and current_time < json_object.data.timings.Dhuhr then
                    prayer = "الظهر"
                    h, m = json_object.data.timings.Dhuhr:match("^(%d%d):(%d%d)$")

                    number_text_widget.text = "الظهر (" .. h .. ":" .. m .. ")"

                    detailed_widget:get_children_by_id("dhuhr_widget")[1].bg = beautiful.prayer_times_inner_bg_color or beautiful.prayer_times_icon_bg_color
                    detailed_widget:get_children_by_id("dhuhr_widget")[1].fg = beautiful.prayer_times_inner_text_color
                end

                set_detailed_time(
                    json_object.data.timings.Fajr,
                    json_object.data.timings.Dhuhr,
                    json_object.data.timings.Asr,
                    json_object.data.timings.Maghrib,
                    json_object.data.timings.Isha
                )

                -- hijri_date.text = json_object.data.date.hijri.month.en
                -- hijri_date.text = json_object.data.date.hijri.date

                -- Set athan timer
                athan_timer.timeout = get_difftime(h, m)
                athan_timer:start()
            end
        )
    end

    calculate_prayer_times()

    -- awesome.connect_signal(
    --     "org.freedesktop.login1.Manager",
    --     "Resuming",
    --     function()
    --         -- awful.spawn.with_shell("notify-send 'HI'")
    --         calculate_prayer_times()
    --     end
    -- )

    awesome.connect_signal(
        "system::resume",
        function()
            awesome.spawn("notify-send عدنا", false)
            calculate_prayer_times()
        end
    )

    number_text_widget:connect_signal(
        "button::press",
        function()
            if popup.visible then
                popup.visible = not popup.visible
            else
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end
    )

    return panal_widget
end

return factory
