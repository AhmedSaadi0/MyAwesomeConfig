local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

awful.screen.connect_for_each_screen(
    function(s)
        if s == screen.primary then
            --------------------------------
            --------- Colors Theme ---------
            --------------------------------
            s.clock =
                require("widget.desktop-clock") {
                line_margin_right = dpi(40),
                line_margin_left = dpi(10),
                day_align = "right"
            }

            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15",
                forced_width = dpi(700)
            }

            s.music =
                require("widget.music") {
                widget_fg = helpers.create_gradient_color {
                    color2 = "#ff4bde",
                    color1 = "#0cdfff",
                    from = {500, 20},
                    to = {0, 0}
                },
                text_font = "JF Flat 15",
                artist_font = "JF Flat 12",
                widget_bg = "#50407800",
                bar_active_color = "#10ddff",
                margin_top=dpi(10),
                bar_color = "#10ddff55"
            }
            s.music2 =
                require("widget.desktop-music") {
                widget_bg = "00000000",
                widget_artist_fg = helpers.create_gradient_color {
                    color2 = "#ff4bde",
                    color1 = "#0cdfff",
                    from = {500, 20},
                    to = {0, 0}
                },
                widget_title_fg = helpers.create_gradient_color {
                    color2 = "#ff4bde",
                    color1 = "#0cdfff",
                    from = {500, 20},
                    to = {0, 0}
                },
                forced_width = dpi(550),
                forced_height = dpi(100),
                title_font = "JF Flat 16",
                artist_font = "JF Flat 14"
            }

            s.final =
                wibox.widget {
                layout = wibox.layout.fixed.horizontal,
                ----------
                -- الساعة --
                ----------
                helpers.set_widget_block {
                    widget = s.clock,
                    bg = beautiful.transparent,
                    right = dpi(5)
                },
                ----------------
                -- الفاصل العرضي --
                ----------------
                helpers.set_widget_block {
                    widget = {
                        text = "",
                        widget = wibox.widget.textbox
                    },
                    shape = gears.shape.rectangle,
                    bg = beautiful.accent,
                    fg = beautiful.accent,
                    right = dpi(1)
                },
                ------------
                -- الموسيقى --
                ------------
                helpers.set_widget_block {
                    widget = s.music,
                    bg = beautiful.transparent,
                    left = dpi(35),
                    right = dpi(10),
                    forced_width = dpi(550),
                },
                ----------------
                -- الفاصل العرضي --
                ----------------
                helpers.set_widget_block {
                    widget = {
                        text = "",
                        widget = wibox.widget.textbox
                    },
                    shape = gears.shape.rectangle,
                    bg = beautiful.accent,
                    fg = beautiful.accent,
                    right = dpi(1)
                },
                ----------
                -- الحكم --
                ----------
                helpers.set_widget_block {
                    widget = s.saying,
                    bg = beautiful.transparent,
                    fg = beautiful.accent,
                    left = dpi(35),
                    right = dpi(10)
                },
                helpers.set_widget_block {
                    widget = {
                        text = "",
                        widget = wibox.widget.textbox
                    },
                    shape = gears.shape.rectangle,
                    bg = beautiful.accent,
                    fg = beautiful.accent,
                    right = dpi(1)
                }
            }

            s.clock_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.transparent,
                type = "desktop",
                offset = {y = 10},
                widget = s.final
            }
            awful.placement.top_left(
                s.clock_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(100),
                        bottom = 0,
                        right = 0,
                        left = dpi(50)
                    },
                    parent = s
                }
            )
        end
    end
)