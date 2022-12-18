local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

awful.screen.connect_for_each_screen(
    function(s)
        if s == screen.primary then
            -------------
            -- Wisdoms --
            -------------
            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15",
                forced_width = dpi(650),
                valign = "center"
            }

            -----------
            -- Music --
            -----------
            s.music =
                require("widget.desktop-music") {
                widget_bg = "#00000000",
                widget_title_fg = "#fe8019",
                widget_artist_fg = "#928374",
                forced_width = dpi(500),
                forced_height = dpi(100),
                title_font = "JF Flat 18",
                artist_font = "JF Flat 16",
            }

            -----------
            -- Clock --
            -----------
            s.clock =
                require("widget.desktop-clock") {
                line_margin_right = dpi(40),
                line_margin_left = dpi(10),
                day_align = "right",
                -- day_number_text_font = "Poiret One 46",
                month_name_text_font = "JF Flat 30",
                fuzzy_time_icon_font = "Font Awesome 5 Free Solid 15",
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
                    left = dpi(40),
                    right = dpi(5),
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
                    left = dpi(40),
                    right = dpi(5)
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
            awful.placement.bottom(
                s.clock_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(0),
                        bottom = dpi(200),
                        right = 0,
                        left = dpi(15)
                    },
                    parent = s
                }
            )
        end
    end
)
