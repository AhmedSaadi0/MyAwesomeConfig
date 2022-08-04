local wibox = require("wibox")
local spawn = require("awful.spawn")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi

local brightness_slider = require("widget.brightness-slider")
local volume_slider = require("widget.volume-slider"){}
local blur_slider = require("widget.blur-slider")

local function worker(args)
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

    local quick_header =
        wibox.widget {
        text = "السطوع",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
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
                        brightness_slider,
                        -- volusme_slider,
                        -- blur_slider
                    },
                    bg = bg,
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
        border_width = border_width,
        border_color = border_color,
        maximum_width = 300,
        offset = {y = 10},
        widget = detailed_widget
    }

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

    awesome.connect_signal(
        "widget::brightness",
        function(c)
            spawn.easy_async_with_shell(
                "light",
                function(stdout)
                    number_text_widget.text = tonumber(string.format("%.0f", stdout)) .. "%"
                end
            )
        end
    )

    awesome.connect_signal(
        "widget::set_brightness",
        function(c)
            number_text_widget.text = tonumber(string.format("%.0f", c)) .. "%"
        end
    )

    spawn.easy_async_with_shell(
        "light",
        function(stdout)
            number_text_widget.text = tonumber(string.format("%.0f", stdout)) .. "%"
        end
    )

    return number_text_widget
end

return worker
