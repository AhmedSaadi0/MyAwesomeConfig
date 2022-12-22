local wibox = require("wibox")
local spawn = require("awful.spawn")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local brightness_slider = require("widget.brightness-slider")
local volume_slider =
    require("widget.volume-slider") {
    slider_top = dpi(0),
    slider_bottom = dpi(0),
    icon_top = dpi(5),
    icon_bottom = dpi(5),
    slider_left = dpi(12),
    slider_right = dpi(30),
    right = dpi(12),
    left = dpi(12),
    forced_height = dpi(32)

    -- left = dpi(0),
    -- right = dpi(0),
}

local music_widget = require("widget.music") {}

local worker = function (args)
    local screen = args.screen or screen.primary

    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local header_bg = args.header_bg or beautiful.header_bg

    local bg = args.bg or beautiful.bg_normal

    local widget_bg = args.widget_bg or beautiful.bg_normal
    local widget_fg = args.widget_fg or beautiful.fg_normal

    local border_width = args.border_width or beautiful.control_border_width
    local border_color = args.border_color or beautiful.border_focus

    local shape = args.shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local number_text_widget =
        wibox.widget {
        text = "00%",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Popup
    local quick_header =
        wibox.widget {
        text = "الصوت",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local sound_settings =
        helpers.add_text_icon_widget {
        text = "اعدادات الصوت",
        icon = "",
        icon_font = beautiful.iconfont,
        text_font = text_font
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(7),
        {
            layout = wibox.layout.fixed.vertical,
            {
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(7),
                {
                    {
                        {
                            {
                                quick_header,
                                left = dpi(24),
                                top = dpi(15),
                                bottom = dpi(15),
                                right = dpi(24),
                                widget = wibox.container.margin
                            },
                            bg = header_bg,
                            widget = wibox.container.background
                        },
                        layout = wibox.layout.fixed.vertical,
                        helpers.add_margin {
                            widget = helpers.set_widget_block {
                                widget = volume_slider,
                                border_width = beautiful.slider_inner_border_width,
                                border_color = beautiful.slider_inner_border_color,		
                                shape = shape
                                -- forced_height = dpi(30),
                            },
                            top = dpi(12),
                            right = dpi(12),
                            left = dpi(12)
                        },
                        helpers.add_margin {
                            widget = music_widget,
                            
                            top = dpi(12),
                            -- bottom = dpi(12),
                            right = dpi(12),
                            left = dpi(12)
                        },
                        helpers.add_margin {
                            widget = helpers.set_widget_block {
                                widget = sound_settings,
                                right = dpi(24),
                                left = dpi(24),
                                border_width = beautiful.slider_inner_border_width,
                                border_color = beautiful.slider_inner_border_color,		
                                shape = shape
                            },
                            top = dpi(12),
                            bottom = dpi(12),
                            right = dpi(12),
                            left = dpi(12)
                        }
                    },
                    bg = bg,
                    fg = widget_fg,
                    shape = shape,
                    widget = wibox.container.background
                }
            }
        }
    }

    local popup =
        awful.popup {
        ontop = true,
        visible = false,
        shape = shape,
        screen = screen,
        border_width = border_width,
        border_color = border_color,
        maximum_width = 320,
        offset = {y = 10},
        widget = detailed_widget
    }


    sound_settings:connect_signal(
        "button::press",
        function()
            awful.spawn("systemsettings5 kcm_pulseaudio")
            popup.visible = not popup.visible
        end
    )

    number_text_widget:connect_signal(
        "button::press",
        function()
            awesome.emit_signal("widget::open_music")
        end
    )

    awesome.connect_signal(
        "widget::open_music",
        function(c)
            popup.visible = not popup.visible

            awful.placement.top_left(
                popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(42),
                        left = dpi(250)
                    },
                    parent = awful.screen.focused()
                }
            )
            -- if popup.visible then
            -- else
            --     popup:move_next_to(mouse.current_widget_geometry)
            -- end
        end
    )

    awesome.connect_signal(
        "widget::volume",
        function(c)
            spawn.easy_async_with_shell(
                "amixer -D pulse sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }'",
                function(stdout)
                    number_text_widget.text = stdout
                end
            )
        end
    )

    awesome.connect_signal(
        "widget::set_volume",
        function(c)
            number_text_widget.text = tonumber(string.format("%.0f", c)) .. "%"
        end
    )

    spawn.easy_async_with_shell(
        "amixer -D pulse sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }'",
        function(stdout)
            number_text_widget.text = stdout
        end
    )

    return number_text_widget
end

return worker
