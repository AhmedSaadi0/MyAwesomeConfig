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

local blue_light = require("widget.blue-light")
local airplane_mode = require("widget.airplane-mode")
local bluetooth_toggle = require("widget.bluetooth-toggle")
-- local nightmode_toggle = require("widget.night-mode")
local blur_toggle = require("widget.blur-toggle")

local theme_switcher = require("widget.theme-switcher.init"){}

local function factory(args)
    local text_font = args.font or beautiful.uifont
    local icon_font = args.font or beautiful.iconfont

    local header_bg = args.header_bg or beautiful.header_bg

    local bg = args.bg or beautiful.bg_normal

    local widget_bg = args.widget_bg or beautiful.bg_normal
    local widget_fg = args.widget_fg or beautiful.fg_normal

    local border_width = args.border_width or beautiful.border_width
    local border_color = args.border_color or beautiful.border_focus

    local shape = args.shape or function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
        end

    local icon =
        wibox.widget {
        text = "",
        font = icon_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Popup
    local quick_header =
        wibox.widget {
        text = "احمد",
        font = text_font,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local power_button =
        helpers.add_text_icon_widget {
        text = "خروج ...",
        icon = "",
        text_font = text_font
    }

    local open_settings =
        helpers.add_text_icon_widget {
        text = "الاعدادات",
        icon = "",
        text_font = text_font
    }

    local wifi_settings =
        helpers.add_text_icon_widget {
        text = "اعدادات الاتصال",
        icon = "",
        text_font = text_font
    }

    local sound_settings =
        helpers.add_text_icon_widget {
        text = "اعدادات الصوت",
        icon = "",
        text_font = text_font
    }

    local detailed_widget =
        wibox.widget {
        layout = wibox.layout.fixed.vertical,
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
            helpers.set_widget_block {
                widget = {
                    layout = wibox.layout.fixed.vertical,
                    -- الخيارات مثل وضع الطيرات
                    helpers.add_margin {
                        widget = helpers.set_widget_block {
                            widget = {
                                layout = wibox.layout.fixed.vertical,
                                blue_light,
                                airplane_mode,
                                bluetooth_toggle,
                                -- nightmode_toggle,
                                blur_toggle
                            },
                            shape = shape
                            -- bottom = dpi(15)
                        },
                        right = dpi(12),
                        left = dpi(12),
                        top = dpi(12),

                        bottom = dpi(12)
                    },
                    -- مبدل الثيمات
                    helpers.add_margin {
                        widget = helpers.set_widget_block {
                            widget = {
                                layout = wibox.layout.fixed.vertical,
                                theme_switcher,
                            },
                            shape = shape
                            -- bottom = dpi(15)
                        },
                        right = dpi(12),
                        left = dpi(12),
                        bottom = dpi(12)
                    },
                    -- الاضائة والصوت والتاصير الضبابي
                    helpers.add_margin {
                        widget = helpers.set_widget_block {
                            widget = {
                                layout = wibox.layout.fixed.vertical,
                                brightness_slider,
                                volume_slider,
                                blur_slider
                            },
                            shape = shape
                            -- bottom = dpi(15)
                        },
                        right = dpi(12),
                        left = dpi(12),
                        bottom = dpi(12)
                    },
                    -- الاختصارات
                    helpers.add_margin {
                        widget = helpers.set_widget_block {
                            widget = {
                                layout = wibox.layout.fixed.vertical,
                                open_settings,
                                wifi_settings,
                                sound_settings,
                            },
                            right = dpi(24),
                            left = dpi(24),
                            shape = shape
                            -- bottom = dpi(15)
                        },
                        right = dpi(12),
                        left = dpi(12),
                        bottom = dpi(12)
                    },
                    -- الخروج
                    helpers.add_margin {
                        widget = helpers.set_widget_block {
                            widget = {
                                layout = wibox.layout.fixed.vertical,
                                power_button,
                            },
                            right = dpi(24),
                            left = dpi(24),
                            shape = shape
                            -- bottom = dpi(15)
                        },
                        right = dpi(12),
                        left = dpi(12),
                        bottom = dpi(12)
                    }
                },
                bg = widget_bg
            },
            layout = wibox.layout.fixed.vertical
        }
    }

    local popup =
        awful.popup {
        ontop = true,
        visible = false,
        shape = shape,
        border_width = border_width,
        border_color = border_color,
        maximum_width = 320,
        offset = {y = 10},
        widget = detailed_widget
    }

    awful.placement.top_left(
		popup,
		{
			margins = {
				-- right = panel_margins,
				top = dpi(42),
				left = dpi(10)
			},
		}
	)

    local show_popup = function()
        popup:move_next_to()
        icon.text = ""
    end

    local hide_popup = function()
        popup.visible = not popup.visible
        icon.text = ""
    end

    power_button:connect_signal(
        "button::press",
        function()
            awesome.emit_signal("module::exit_screen:show")
            hide_popup()
        end
    )

    open_settings:connect_signal(
        "button::press",
        function()
            awful.spawn("systemsettings5")
            hide_popup()
        end
    )

    wifi_settings:connect_signal(
        "button::press",
        function()
            awful.spawn("systemsettings5 kcm_networkmanagement")
            hide_popup()
        end
    )

    sound_settings:connect_signal(
        "button::press",
        function()
            awful.spawn("systemsettings5 kcm_pulseaudio")
            hide_popup()
        end
    )

    icon:connect_signal(
        "button::press",
        function()
            if popup.visible then
                hide_popup()
            else
                show_popup()
            end
        end
    )

    awesome.connect_signal(
        "widget::open_left_menu",
        function(c)
            if popup.visible then
                hide_popup()
            else
                show_popup()
            end
        end
    )


    return icon
end

return factory
