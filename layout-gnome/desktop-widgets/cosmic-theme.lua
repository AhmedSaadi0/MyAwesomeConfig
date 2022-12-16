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
            --------- Circle Theme ---------
            --------------------------------
            -------------
            -- Wisdoms --
            -------------
            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15",
                forced_width = dpi(500),
                forced_height = dpi(390),
                valign = "top"
            }

            s.saying_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = "#00000000",
                type = "desktop",
                offset = {y = 10},
                fg = "#928374",
                widget = s.saying
            }
            awful.placement.top_right(
                s.saying_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(100),
                        bottom = dpi(0),
                        right = dpi(60),
                        left = dpi(0)
                    },
                    parent = s
                }
            )

            -----------
            -- Music --
            -----------
            s.music =
                require("widget.desktop-music") {
                widget_bg = "#00000000",
                widget_title_fg = "#928374",
                widget_artist_fg = "#fe8019",
                forced_width = dpi(490),
                title_font = "JF Flat 20",
                forced_height = 150,
                artist_font = "JF Flat 16"
            }

            s.music_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = "#00000000",
                type = "desktop",
                offset = {y = 10},
                widget = s.music
            }
            awful.placement.bottom_right(
                s.music_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(0),
                        bottom = dpi(0),
                        right = dpi(60),
                        left = dpi(0)
                    },
                    parent = s
                }
            )

            -----------
            -- Clock --
            -----------
            s.clock = require("widget.desktop-clock") {}
            s.clock_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.transparent,
                type = "desktop",
                maximum_width = dpi(450),
                offset = {y = 10},
                widget = s.clock
            }
            awful.placement.top_left(
                s.clock_popup,
                {
                    margins = {
                        top = dpi(600),
                        bottom = dpi(0),
                        right = dpi(0),
                        left = dpi(340)
                    },
                    parent = s
                }
            )
        end
    end
)
