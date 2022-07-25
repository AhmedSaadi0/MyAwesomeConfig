local wibox = require("wibox")
local spawn = require("awful.spawn")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()

local brightness_slider = require("widget.brightness-slider")
local volume_slider = require("widget.volume-slider") {}
local blur_slider = require("widget.blur-slider")

local selected_theme = "NO_THEME"

local function worker(args)
    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local selected_text_color = args.selected_text_color or beautiful.bg_normal
    local selected_bg_color = args.selected_bg_color or beautiful.accent

    local shape = args.shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local islamic_theme =
        helpers.add_text_icon_widget {
        text = "عربي",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        forced_width = dpi(72)
    }

    local dark_theme =
        helpers.add_text_icon_widget {
        text = "مظلم",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        forced_width = dpi(72)
    }

    local light_theme =
        helpers.add_text_icon_widget {
        text = "مضيء",
        icon = "",
        text_font = text_font,
        icon_font = icon_font,
        forced_width = dpi(72)
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.manual,
        forced_height = dpi(80),
        -- عربي
        {
            point = function(geo, args)
                return {
                    x = 0,
                    y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                }
            end,
            layout = wibox.layout.fixed.vertical,
            helpers.add_margin {
                widget = helpers.set_widget_block {
                    widget = islamic_theme,
                    id = "arabic",
                    shape = shape,
                    top = dpi(8),
                    bottom = dpi(8),
                    right = dpi(8),
                    left = dpi(8)
                },
                top = dpi(8),
                bottom = dpi(8),
                right = dpi(8),
                left = dpi(8)
            }
        },
        -- مظلم
        {
            point = function(geo, args)
                return {
                    x = (args.parent.width / 2 + (geo.width / 2)) - geo.width,
                    y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                }
            end,
            layout = wibox.layout.fixed.vertical,
            helpers.add_margin {
                widget = helpers.set_widget_block {
                    widget = dark_theme,
                    id = "dark",
                    shape = shape,
                    top = dpi(8),
                    bottom = dpi(8),
                    right = dpi(8),
                    left = dpi(8)
                },
                top = dpi(8),
                bottom = dpi(8),
                right = dpi(8),
                left = dpi(8)
            }
        },
        -- مضيء
        {
            point = function(geo, args)
                return {
                    x = args.parent.width - geo.width,
                    y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                }
            end,
            layout = wibox.layout.fixed.vertical,
            helpers.add_margin {
                widget = helpers.set_widget_block {
                    widget = light_theme,
                    id = "light",
                    shape = shape,
                    top = dpi(8),
                    bottom = dpi(8),
                    right = dpi(8),
                    left = dpi(8)
                },
                top = dpi(8),
                bottom = dpi(8),
                right = dpi(8),
                left = dpi(8)
            }
        }
    }

    local function set_arabic(on)
        if on then
            islamic_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("عربي", selected_text_color, text_font)
            islamic_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", selected_text_color, icon_font)
            detailed_widget:get_children_by_id("arabic")[1].bg = selected_bg_color
        else
            islamic_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("عربي", nil, text_font)
            islamic_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", nil, icon_font)
            detailed_widget:get_children_by_id("arabic")[1].bg = beautiful.widget_bg
        end
    end

    local function set_dark(on)
        if on then
            dark_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("مظلم", selected_text_color, text_font)
            dark_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", selected_text_color, icon_font)
            detailed_widget:get_children_by_id("dark")[1].bg = selected_bg_color
        else
            dark_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("مظلم", nil, text_font)
            dark_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", nil, icon_font)
            detailed_widget:get_children_by_id("dark")[1].bg = beautiful.widget_bg
        end
    end

    local function set_light(on)
        if on then
            light_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("مضيء", selected_text_color, text_font)
            light_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", selected_text_color, icon_font)
            detailed_widget:get_children_by_id("light")[1].bg = selected_bg_color
        else
            light_theme:get_children_by_id("text_id")[1].markup  = helpers.colorize_text("مضيء", nil, text_font)
            light_theme:get_children_by_id("icon_id")[1].markup  = helpers.colorize_text("", nil, icon_font)
            detailed_widget:get_children_by_id("light")[1].bg = beautiful.widget_bg
        end
    end


    local check_status = function()
        awful.spawn.easy_async_with_shell(
            [[bash -c "grep -F '_theme' ]] .. config_dir .. [[rc.lua | tr -d '[\"\;\=\ ]'"]],
            function(stdout, stderr)
                if string.find(stdout, "light_theme") then
                    set_light(true)
                    set_dark(false)
                    set_arabic(false)
                    selected_theme = "light_theme"
                elseif string.find(stdout, "islamic_theme") then
                    set_light(false)
                    set_dark(false)
                    set_arabic(true)
                    selected_theme = "islamic_theme"
                elseif string.find(stdout, "dark_theme") then
                    set_light(false)
                    set_dark(true)
                    set_arabic(false)
                    selected_theme = "dark_theme"
                end
            end
        )
    end

    check_status()

    local toggle_night_mode = function(theme)
        local toggle_n_m_script = "sed -i 's/" .. selected_theme .. "/" .. theme .. "/' " .. config_dir .. "rc.lua"
        awful.spawn.with_shell(toggle_n_m_script)
        awful.spawn.with_shell("echo 'awesome.restart()' | awesome-client")
    end
    
    islamic_theme:connect_signal(
        "button::press",
        function()
            toggle_night_mode("islamic_theme")
        end
    )
    dark_theme:connect_signal(
        "button::press",
        function()
            toggle_night_mode("dark_theme")
        end
    )
    light_theme:connect_signal(
        "button::press",
        function()
            toggle_night_mode("light_theme")
        end
    )

    return detailed_widget
end

return worker
