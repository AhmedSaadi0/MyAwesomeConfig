local wibox = require("wibox")
local helpers = require("helpers")
local awful = require("awful")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local json = require("library.json")

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

    watch(
        "curl 'https://api.aladhan.com/v1/timingsByCity?city=" ..
            city .. "&country=" .. country .. "&method=" .. method .. "'",
        3600,
        function(_, stdout)
            if stdout == "" then
                number_text_widget.text = "غير متوفرة حاليا"
                return
            end

            local json_object = json.parse(stdout)

            local current_time = os.date("%H:%M")

            if current_time > json_object.data.timings.Isha then
                number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
            elseif current_time > json_object.data.timings.Maghrib then
                local h, m = json_object.data.timings.Isha:match("^(%d%d):(%d%d)$")
                h = (h - 12)
                number_text_widget.text = "العشاء (0" .. h .. ":" .. m .. ")"
            elseif current_time > json_object.data.timings.Asr then
                local h, m = json_object.data.timings.Maghrib:match("^(%d%d):(%d%d)$")
                h = (h - 12)
                number_text_widget.text = "المغرب (0" .. h .. ":" .. m .. ")"
            elseif current_time > json_object.data.timings.Dhuhr then
                local h, m = json_object.data.timings.Asr:match("^(%d%d):(%d%d)$")
                h = (h - 12)
                number_text_widget.text = "العصر (0" ..  h .. ":" .. m  .. ")"
            elseif current_time > json_object.data.timings.Fajr then
                number_text_widget.text = "الظهر (" .. json_object.data.timings.Dhuhr .. ")"
            end
        end
    )

    -- awful.spawn.easy_async_with_shell(
    --     "curl 'https://api.aladhan.com/v1/timingsByCity?city=" ..
    --         city .. "&country=" .. country .. "&method=" .. method .. "'",
    --     function(stdout)
    --         if stdout == "" then
    --             number_text_widget.text = "غير متوفرة حاليا"
    --             return
    --         end

    --         local json_object = json.parse(stdout)

    --         local current_time = os.date("%H:%M")

    --         if current_time > json_object.data.timings.Isha then
    --             number_text_widget.text = "الفجر (" .. json_object.data.timings.Fajr .. ")"
    --         elseif current_time > json_object.data.timings.Maghrib then
    --             number_text_widget.text = "العشاء (" .. json_object.data.timings.Isha .. ")"
    --         elseif current_time > json_object.data.timings.Asr then
    --             number_text_widget.text = "المغرب (" .. json_object.data.timings.Maghrib .. ")"
    --         elseif current_time > json_object.data.timings.Dhuhr then
    --             number_text_widget.text = "العصر (" .. json_object.data.timings.Asr .. ")"
    --         elseif current_time > json_object.data.timings.Fajr then
    --             number_text_widget.text = "الظهر (" .. json_object.data.timings.Dhuhr .. ")"
    --         end

    --         -- number_text_widget.text = os.date('%H-%M')
    --     end
    -- )

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
