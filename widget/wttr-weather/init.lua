local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local json = require("library.json")

local weather_json = ""

local sun_icon_dic = {}
local moon_icon_dic = {}

sun_icon_dic["395"] = ""
sun_icon_dic["392"] = "⛈"
sun_icon_dic["389"] = "⛈"
sun_icon_dic["386"] = "⛈"
sun_icon_dic["377"] = ""
sun_icon_dic["374"] = ""
sun_icon_dic["371"] = ""
sun_icon_dic["368"] = ""
sun_icon_dic["365"] = ""
sun_icon_dic["362"] = ""
sun_icon_dic["359"] = ""
sun_icon_dic["356"] = ""
sun_icon_dic["353"] = ""
sun_icon_dic["350"] = ""
sun_icon_dic["338"] = ""
sun_icon_dic["335"] = ""
sun_icon_dic["332"] = ""
sun_icon_dic["329"] = ""
sun_icon_dic["326"] = ""
sun_icon_dic["323"] = ""
sun_icon_dic["320"] = ""
sun_icon_dic["317"] = ""
sun_icon_dic["314"] = ""
sun_icon_dic["311"] = ""
sun_icon_dic["308"] = ""
sun_icon_dic["305"] = ""
sun_icon_dic["302"] = ""
sun_icon_dic["299"] = ""
sun_icon_dic["296"] = ""
sun_icon_dic["293"] = ""
sun_icon_dic["284"] = ""
sun_icon_dic["281"] = ""
sun_icon_dic["266"] = ""
sun_icon_dic["263"] = ""
sun_icon_dic["260"] = "🌫"
sun_icon_dic["248"] = "🌫"
sun_icon_dic["230"] = ""
sun_icon_dic["227"] = ""
sun_icon_dic["200"] = "⛈"
sun_icon_dic["185"] = ""
sun_icon_dic["182"] = ""
sun_icon_dic["179"] = ""
sun_icon_dic["176"] = ""
sun_icon_dic["143"] = "🌫"
sun_icon_dic["122"] = "🌥"
sun_icon_dic["119"] = ""
sun_icon_dic["116"] = ""
sun_icon_dic["113"] = ""

moon_icon_dic["395"] = ""
moon_icon_dic["392"] = "⛈"
moon_icon_dic["389"] = "⛈"
moon_icon_dic["386"] = "⛈"
moon_icon_dic["377"] = ""
moon_icon_dic["374"] = ""
moon_icon_dic["371"] = ""
moon_icon_dic["368"] = ""
moon_icon_dic["365"] = ""
moon_icon_dic["362"] = ""
moon_icon_dic["359"] = ""
moon_icon_dic["356"] = ""
moon_icon_dic["353"] = ""
moon_icon_dic["350"] = ""
moon_icon_dic["338"] = ""
moon_icon_dic["335"] = ""
moon_icon_dic["332"] = ""
moon_icon_dic["329"] = ""
moon_icon_dic["326"] = ""
moon_icon_dic["323"] = ""
moon_icon_dic["320"] = ""
moon_icon_dic["317"] = ""
moon_icon_dic["314"] = ""
moon_icon_dic["311"] = ""
moon_icon_dic["308"] = ""
moon_icon_dic["305"] = ""
moon_icon_dic["302"] = ""
moon_icon_dic["299"] = ""
moon_icon_dic["296"] = ""
moon_icon_dic["293"] = ""
moon_icon_dic["284"] = ""
moon_icon_dic["281"] = ""
moon_icon_dic["266"] = ""
moon_icon_dic["263"] = ""
moon_icon_dic["260"] = "🌫"
moon_icon_dic["248"] = "🌫"
moon_icon_dic["230"] = ""
moon_icon_dic["227"] = ""
moon_icon_dic["200"] = "⛈"
moon_icon_dic["185"] = ""
moon_icon_dic["182"] = ""
moon_icon_dic["179"] = ""
moon_icon_dic["176"] = ""
moon_icon_dic["143"] = "🌫"
moon_icon_dic["122"] = "🌥"
moon_icon_dic["119"] = ""
moon_icon_dic["116"] = ""
moon_icon_dic["113"] = ""

local function factory(args)
    local city = args.city or beautiful.city or "Sanaa"
    
    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local header_bg = args.header_bg or beautiful.header_bg

    local bg = args.bg or beautiful.bg_normal

    local widget_bg = args.widget_bg or beautiful.bg_normal
    local widget_fg = args.widget_fg or beautiful.fg_normal
    
    local border_width = args.border_width or beautiful.border_width
    local border_color = args.border_color or beautiful.border_focus

    local popup_shape = args.popup_shape or function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end

    local widget_shape = args.widget_shape or function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
    end

    local number_text_widget =
        wibox.widget {
        text = "",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local icon =
        wibox.widget {
        markup = helpers.colorize_text("", beautiful.weather_icon_fg_color, icon_font),
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local weather_widget =
        wibox.widget {
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
            right = 4,
            left = 4
        },
        layout = wibox.layout.fixed.horizontal
    }

    --------------------
    --  POP UP Widget --
    --------------------
    local header =
        wibox.widget {
        text = "الصقس",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local today_1 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local today_2 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local today_3 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local today_4 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        sky_status_id = "sky_status_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }

    local tomorrow_1 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local tomorrow_2 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local tomorrow_3 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local tomorrow_4 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }

    local after_tomorrow_1 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local after_tomorrow_2 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local after_tomorrow_3 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }
    local after_tomorrow_4 =
        helpers.create_weather_detailed {
        temperature_id = "temperature_id",
        moonrise_id = "moonrise_id",
        sunrise_id = "sunrise_id",
        sky_status_id = "sky_status_id",
        weather_icon_id = "weather_icon_id",
        temperature_time_id = "temperature_time_id",
        temperature_date_id = "temperature_date_id",
        temperature_city_id = "temperature_city_id",
        h_l_temperature_id = "h_l_temperature_id"
    }

    -- Today
    local widget_1 = helpers.add_margin {
        widget = helpers.set_widget_block {
            widget = today_1,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_2 = helpers.add_margin {
        visible = false,
        id = "widget_2",
        widget = helpers.set_widget_block {
            widget = today_2,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_3 = helpers.add_margin {
        visible = false,
        id = "widget_3",
        widget = helpers.set_widget_block {
            widget = today_3,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_4 = helpers.add_margin {
        visible = false,
        id = "widget_4",
        right = dpi(24),
        widget = helpers.set_widget_block {
            widget = today_4,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        }
    }

    -- Tomorrow
    local widget_5 = helpers.add_margin {
        widget = helpers.set_widget_block {
            widget = tomorrow_1,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_6 = helpers.add_margin {
        visible = false,
        id = "widget_6",
        widget = helpers.set_widget_block {
            widget = tomorrow_2,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_7 = helpers.add_margin {
        visible = false,
        id = "widget_7",
        widget = helpers.set_widget_block {
            widget = tomorrow_3,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_8 = helpers.add_margin {
        visible = false,
        id = "widget_8",
        right = dpi(24),
        widget = helpers.set_widget_block {
            widget = tomorrow_4,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        }
    }

    -- After Tomorrow
    local widget_9 = helpers.add_margin {
        widget = helpers.set_widget_block {
            widget = after_tomorrow_1,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_10 = helpers.add_margin {
        visible = false,
        id = "widget_10",
        widget = helpers.set_widget_block {
            widget = after_tomorrow_2,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_11 = helpers.add_margin {
        visible = false,
        id = "widget_11",
        widget = helpers.set_widget_block {
            widget = after_tomorrow_3,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        },
        right = dpi(24)
    }

    local widget_12 = helpers.add_margin {
        visible = false,
        id = "widget_12",
        right = dpi(24),
        widget = helpers.set_widget_block {
            widget = after_tomorrow_4,
            shape = widget_shape,
            bg = widget_bg,
            fg = widget_fg,
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(10),
            right = dpi(10)
        }
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
                        left = dpi(24),
                        top = dpi(15),
                        bottom = dpi(15),
                        right = dpi(24),
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
                    top = dpi(24),
                    bottom = dpi(24),
                    left = dpi(24),
                    -- right = dpi(24),
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.fixed.horizontal,
                        widget_5,
                        widget_6,
                        widget_7,
                        widget_8,
                    },
                    -- top = dpi(24),
                    bottom = dpi(24),
                    left = dpi(24),
                    -- right = dpi(24),
                    bg = beautiful.transparent
                },helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.fixed.horizontal,
                        widget_9,
                        widget_10,
                        widget_11,
                        widget_12,
                    },
                    -- top = dpi(24),
                    bottom = dpi(24),
                    left = dpi(24),
                    -- right = dpi(24),
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

    watch(
        "curl ar.wttr.in/'".. city .."?format=j1'",
        -- "cat w.txt",
        900,
        function(_, stdout)
            if stdout == "" then
                number_text_widget.text = "خدمة الطقس غير متوفرة"
                return
            end

            weather_json = json.parse(stdout)
            detailed_widget.visible = true


            local lang_ar = weather_json.current_condition[1].lang_ar[1].value
            local today_time = weather_json.current_condition[1].localObsDateTime
            local code = weather_json.current_condition[1].weatherCode
            local city = weather_json.nearest_area[1].areaName[1].value

            local year, month, day, hours, minutes, am_pm =
                today_time:match("^(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d) ([AP]M)$")

            local w_icon = ""

            if (am_pm == "AM" and tonumber(hours) > 5) or (am_pm == "PM" and tonumber(hours) < 6) then
                w_icon = sun_icon_dic[code]
            else
                w_icon = moon_icon_dic[code]
            end

            icon.markup = helpers.colorize_text(w_icon, beautiful.weather_icon_fg_color, icon_font)

            number_text_widget.text = weather_json.current_condition[1].temp_C .. "°C - " .. lang_ar

            -------------------------------------
            -- Today Weather 4 defferent times --
            -------------------------------------
            local year, month, day = weather_json.weather[1].date:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
            today_1:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.current_condition[1].temp_C)
            today_1:get_children_by_id("sky_status_id")[1]:set_text(weather_json.current_condition[1].lang_ar[1].value)
            today_1:get_children_by_id("weather_icon_id")[1]:set_text(w_icon)
            today_1:get_children_by_id("temperature_time_id")[1]:set_text(weather_json.current_condition[1].observation_time)
            today_1:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            today_1:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            today_1:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            today_1:get_children_by_id("temperature_city_id")[1]:set_text(city)
            today_1:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[1].maxtempC .. "/°" .. weather_json.weather[1].mintempC)

            -- mouse::enter
            today_1:connect_signal(
                "mouse::enter",
                function()
                    detailed_widget:get_children_by_id("widget_2")[1].visible = true
                    detailed_widget:get_children_by_id("widget_3")[1].visible = true
                    detailed_widget:get_children_by_id("widget_4")[1].visible = true
                end
            )

            -- mouse::leave
            today_1:connect_signal(
                "mouse::leave",
                function()
                    detailed_widget:get_children_by_id("widget_2")[1].visible = false
                    detailed_widget:get_children_by_id("widget_3")[1].visible = false
                    detailed_widget:get_children_by_id("widget_4")[1].visible = false
                end
            )
            today_2:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[1].hourly[4].tempC)
            today_2:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[1].hourly[4].lang_ar[1].value)
            today_2:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[1].hourly[4].weatherCode])
            today_2:get_children_by_id("temperature_time_id")[1]:set_text("09:00")
            today_2:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            today_2:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            today_2:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            today_2:get_children_by_id("temperature_city_id")[1]:set_text(city)
            today_2:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[1].maxtempC .. "/°" .. weather_json.weather[1].mintempC)

            today_3:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[1].hourly[6].tempC)
            today_3:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[1].hourly[6].lang_ar[1].value)
            today_3:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[1].hourly[6].weatherCode])
            today_3:get_children_by_id("temperature_time_id")[1]:set_text("15:00")
            today_3:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            today_3:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            today_3:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            today_3:get_children_by_id("temperature_city_id")[1]:set_text(city)
            today_3:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[1].maxtempC .. "/°" .. weather_json.weather[1].mintempC)

            today_4:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[1].hourly[8].tempC)
            today_4:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[1].hourly[8].lang_ar[1].value)
            today_4:get_children_by_id("weather_icon_id")[1]:set_text(moon_icon_dic[weather_json.weather[1].hourly[8].weatherCode])
            today_4:get_children_by_id("temperature_time_id")[1]:set_text("21:00")
            today_4:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            today_4:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            today_4:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            today_4:get_children_by_id("temperature_city_id")[1]:set_text(city)
            today_4:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[1].maxtempC .. "/°" .. weather_json.weather[1].mintempC)

            ----------------------------------------
            -- Tomorrow Weather 4 defferent times --
            ----------------------------------------
            local year, month, day = weather_json.weather[2].date:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
            tomorrow_1:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[2].hourly[4].tempC)
            tomorrow_1:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[2].hourly[4].lang_ar[1].value)
            tomorrow_1:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[2].hourly[4].weatherCode])
            tomorrow_1:get_children_by_id("temperature_time_id")[1]:set_text("12:00")
            tomorrow_1:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            tomorrow_1:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            tomorrow_1:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            tomorrow_1:get_children_by_id("temperature_city_id")[1]:set_text(city)
            tomorrow_1:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[2].maxtempC .. "/°" .. weather_json.weather[2].mintempC)

            -- mouse::enter
            tomorrow_1:connect_signal(
                "mouse::enter",
                function()
                    detailed_widget:get_children_by_id("widget_6")[1].visible = true
                    detailed_widget:get_children_by_id("widget_7")[1].visible = true
                    detailed_widget:get_children_by_id("widget_8")[1].visible = true
                end
            )

            -- mouse::leave
            tomorrow_1:connect_signal(
                "mouse::leave",
                function()
                    detailed_widget:get_children_by_id("widget_6")[1].visible = false
                    detailed_widget:get_children_by_id("widget_7")[1].visible = false
                    detailed_widget:get_children_by_id("widget_8")[1].visible = false
                end
            )

            tomorrow_2:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[2].hourly[3].tempC)
            tomorrow_2:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[2].hourly[3].lang_ar[1].value)
            tomorrow_2:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[2].hourly[3].weatherCode])
            tomorrow_2:get_children_by_id("temperature_time_id")[1]:set_text("09:00")
            tomorrow_2:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            tomorrow_2:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            tomorrow_2:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            tomorrow_2:get_children_by_id("temperature_city_id")[1]:set_text(city)
            tomorrow_2:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[2].maxtempC .. "/°" .. weather_json.weather[2].mintempC)

            tomorrow_3:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[2].hourly[6].tempC)
            tomorrow_3:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[2].hourly[6].lang_ar[1].value)
            tomorrow_3:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[2].hourly[6].weatherCode])
            tomorrow_3:get_children_by_id("temperature_time_id")[1]:set_text("15:00")
            tomorrow_3:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            tomorrow_3:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            tomorrow_3:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            tomorrow_3:get_children_by_id("temperature_city_id")[1]:set_text(city)
            tomorrow_3:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[2].maxtempC .. "/°" .. weather_json.weather[2].mintempC)

            tomorrow_4:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[2].hourly[8].tempC)
            tomorrow_4:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[2].hourly[8].lang_ar[1].value)
            tomorrow_4:get_children_by_id("weather_icon_id")[1]:set_text(moon_icon_dic[weather_json.weather[2].hourly[8].weatherCode])
            tomorrow_4:get_children_by_id("temperature_time_id")[1]:set_text("21:00")
            tomorrow_4:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            tomorrow_4:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            tomorrow_4:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " .. month .. "/" .. day)
            tomorrow_4:get_children_by_id("temperature_city_id")[1]:set_text(city)
            tomorrow_4:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[2].maxtempC .. "/°" .. weather_json.weather[2].mintempC)

            ----------------------------------------------
            -- After tomorrow Weather 4 defferent times --
            ----------------------------------------------
            local year, month, day = weather_json.weather[3].date:match("^(%d%d%d%d)-(%d%d)-(%d%d)$")
            after_tomorrow_1:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[3].hourly[4].tempC)
            after_tomorrow_1:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[3].hourly[4].lang_ar[1].value)
            after_tomorrow_1:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[3].hourly[4].weatherCode])
            after_tomorrow_1:get_children_by_id("temperature_time_id")[1]:set_text("12:00")
            after_tomorrow_1:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            after_tomorrow_1:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            after_tomorrow_1:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " ..  month .. "/" .. day)
            after_tomorrow_1:get_children_by_id("temperature_city_id")[1]:set_text(city)
            after_tomorrow_1:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[3].maxtempC .. "/°" .. weather_json.weather[3].mintempC)

            -- mouse::enter
            after_tomorrow_1:connect_signal(
                "mouse::enter",
                function()
                    detailed_widget:get_children_by_id("widget_10")[1].visible = true
                    detailed_widget:get_children_by_id("widget_11")[1].visible = true
                    detailed_widget:get_children_by_id("widget_12")[1].visible = true
                end
            )

            -- mouse::leave
            after_tomorrow_1:connect_signal(
                "mouse::leave",
                function()
                    detailed_widget:get_children_by_id("widget_10")[1].visible = false
                    detailed_widget:get_children_by_id("widget_11")[1].visible = false
                    detailed_widget:get_children_by_id("widget_12")[1].visible = false
                end
            )
            
            after_tomorrow_2:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[3].hourly[3].tempC)
            after_tomorrow_2:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[3].hourly[3].lang_ar[1].value)
            after_tomorrow_2:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[3].hourly[3].weatherCode])
            after_tomorrow_2:get_children_by_id("temperature_time_id")[1]:set_text("09:00")
            after_tomorrow_2:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            after_tomorrow_2:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            after_tomorrow_2:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " ..  month .. "/" .. day)
            after_tomorrow_2:get_children_by_id("temperature_city_id")[1]:set_text(city)
            after_tomorrow_2:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[3].maxtempC .. "/°" .. weather_json.weather[3].mintempC)
            
            after_tomorrow_3:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[3].hourly[7].tempC)
            after_tomorrow_3:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[3].hourly[6].lang_ar[1].value)
            after_tomorrow_3:get_children_by_id("weather_icon_id")[1]:set_text(sun_icon_dic[weather_json.weather[3].hourly[6].weatherCode])
            after_tomorrow_3:get_children_by_id("temperature_time_id")[1]:set_text("15:00")
            after_tomorrow_3:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            after_tomorrow_3:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            after_tomorrow_3:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " ..  month .. "/" .. day)
            after_tomorrow_3:get_children_by_id("temperature_city_id")[1]:set_text(city)
            after_tomorrow_3:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[3].maxtempC .. "/°" .. weather_json.weather[3].mintempC)

            after_tomorrow_4:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.weather[3].hourly[8].tempC)
            after_tomorrow_4:get_children_by_id("sky_status_id")[1]:set_text(weather_json.weather[3].hourly[8].lang_ar[1].value)
            after_tomorrow_4:get_children_by_id("weather_icon_id")[1]:set_text(moon_icon_dic[weather_json.weather[3].hourly[8].weatherCode])
            after_tomorrow_4:get_children_by_id("temperature_time_id")[1]:set_text("21:00")
            after_tomorrow_4:get_children_by_id("moonrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset)
            after_tomorrow_4:get_children_by_id("sunrise_id")[1]:set_text(" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset)
            after_tomorrow_4:get_children_by_id("temperature_date_id")[1]:set_text(" " .. os.date("%A", os.time{year=year, month=month, day=day}) .. " | " ..  month .. "/" .. day)
            after_tomorrow_4:get_children_by_id("temperature_city_id")[1]:set_text(city)
            after_tomorrow_4:get_children_by_id("h_l_temperature_id")[1]:set_text("°" .. weather_json.weather[3].maxtempC .. "/°" .. weather_json.weather[3].mintempC)

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

    return weather_widget
end

return factory

-- WeatherCode	Condition	DayIcon	NightIcon
-- 395	Moderate or heavy snow in area with thunder	wsymbol_0012_heavy_snow_showers	wsymbol_0028_heavy_snow_showers_night
-- 392	Patchy light snow in area with thunder	wsymbol_0016_thundery_showers	wsymbol_0032_thundery_showers_night
-- 389	Moderate or heavy rain in area with thunder	wsymbol_0024_thunderstorms	wsymbol_0040_thunderstorms_night
-- 386	Patchy light rain in area with thunder	wsymbol_0016_thundery_showers	wsymbol_0032_thundery_showers_night
-- 377	Moderate or heavy showers of ice pellets	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 374	Light showers of ice pellets	wsymbol_0013_sleet_showers	wsymbol_0029_sleet_showers_night
-- 371	Moderate or heavy snow showers	wsymbol_0012_heavy_snow_showers	wsymbol_0028_heavy_snow_showers_night
-- 368	Light snow showers	wsymbol_0011_light_snow_showers	wsymbol_0027_light_snow_showers_night
-- 365	Moderate or heavy sleet showers	wsymbol_0013_sleet_showers	wsymbol_0029_sleet_showers_night
-- 362	Light sleet showers	wsymbol_0013_sleet_showers	wsymbol_0029_sleet_showers_night
-- 359	Torrential rain shower	wsymbol_0018_cloudy_with_heavy_rain	wsymbol_0034_cloudy_with_heavy_rain_night
-- 356	Moderate or heavy rain shower	wsymbol_0010_heavy_rain_showers	wsymbol_0026_heavy_rain_showers_night
-- 353	Light rain shower	wsymbol_0009_light_rain_showers	wsymbol_0025_light_rain_showers_night
-- 350	Ice pellets	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 338	Heavy snow	wsymbol_0020_cloudy_with_heavy_snow	wsymbol_0036_cloudy_with_heavy_snow_night
-- 335	Patchy heavy snow	wsymbol_0012_heavy_snow_showers	wsymbol_0028_heavy_snow_showers_night
-- 332	Moderate snow	wsymbol_0020_cloudy_with_heavy_snow	wsymbol_0036_cloudy_with_heavy_snow_night
-- 329	Patchy moderate snow	wsymbol_0020_cloudy_with_heavy_snow	wsymbol_0036_cloudy_with_heavy_snow_night
-- 326	Light snow	wsymbol_0011_light_snow_showers	wsymbol_0027_light_snow_showers_night
-- 323	Patchy light snow	wsymbol_0011_light_snow_showers	wsymbol_0027_light_snow_showers_night
-- 320	Moderate or heavy sleet	wsymbol_0019_cloudy_with_light_snow	wsymbol_0035_cloudy_with_light_snow_night
-- 317	Light sleet	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 314	Moderate or Heavy freezing rain	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 311	Light freezing rain	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 308	Heavy rain	wsymbol_0018_cloudy_with_heavy_rain	wsymbol_0034_cloudy_with_heavy_rain_night
-- 305	Heavy rain at times	wsymbol_0010_heavy_rain_showers	wsymbol_0026_heavy_rain_showers_night
-- 302	Moderate rain	wsymbol_0018_cloudy_with_heavy_rain	wsymbol_0034_cloudy_with_heavy_rain_night
-- 299	Moderate rain at times	wsymbol_0010_heavy_rain_showers	wsymbol_0026_heavy_rain_showers_night
-- 296	Light rain	wsymbol_0017_cloudy_with_light_rain	wsymbol_0025_light_rain_showers_night
-- 293	Patchy light rain	wsymbol_0017_cloudy_with_light_rain	wsymbol_0033_cloudy_with_light_rain_night
-- 284	Heavy freezing drizzle	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 281	Freezing drizzle	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 266	Light drizzle	wsymbol_0017_cloudy_with_light_rain	wsymbol_0033_cloudy_with_light_rain_night
-- 263	Patchy light drizzle	wsymbol_0009_light_rain_showers	wsymbol_0025_light_rain_showers_night
-- 260	Freezing fog	wsymbol_0007_fog	wsymbol_0007_fog
-- 248	Fog	wsymbol_0007_fog	wsymbol_0007_fog
-- 230	Blizzard	wsymbol_0020_cloudy_with_heavy_snow	wsymbol_0036_cloudy_with_heavy_snow_night
-- 227	Blowing snow	wsymbol_0019_cloudy_with_light_snow	wsymbol_0035_cloudy_with_light_snow_night
-- 200	Thundery outbreaks in nearby	wsymbol_0016_thundery_showers	wsymbol_0032_thundery_showers_night
-- 185	Patchy freezing drizzle nearby	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 182	Patchy sleet nearby	wsymbol_0021_cloudy_with_sleet	wsymbol_0037_cloudy_with_sleet_night
-- 179	Patchy snow nearby	wsymbol_0013_sleet_showers	wsymbol_0029_sleet_showers_night
-- 176	Patchy rain nearby	wsymbol_0009_light_rain_showers	wsymbol_0025_light_rain_showers_night
-- 143	Mist	wsymbol_0006_mist	wsymbol_0006_mist
-- 122	Overcast	wsymbol_0004_black_low_cloud	wsymbol_0004_black_low_cloud
-- 119	Cloudy	wsymbol_0003_white_cloud	wsymbol_0004_black_low_cloud
-- 116	Partly Cloudy	wsymbol_0002_sunny_intervals	wsymbol_0008_clear_sky_night
-- 113	Clear/Sunny	wsymbol_0001_sunny	wsymbol_0008_clear_sky_night
