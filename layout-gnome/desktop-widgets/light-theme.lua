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
            --------- Light Theme ---------
            --------------------------------
            -------------
            -- Wisdoms --
            -------------
            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15",
                forced_width = dpi(790),
                forced_height = dpi(350),
                valign = "top"
            }

            s.saying_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = "#00000000",
                type = "desktop",
                forced_width = dpi(790),
                offset = {y = 10},
                fg = beautiful.accent,
                widget = s.saying
            }
            awful.placement.top(
                s.saying_popup,
                {
                    margins = {
                        top = dpi(585),
                        bottom = dpi(0),
                        right = dpi(55),
                        left = dpi(0)
                    },
                    parent = s
                }
            )

            -----------
            -- Music --
            -----------
            s.music =
                require("widget.music") {
                widget_fg = beautiful.accent,
                text_font = "JF Flat 15",
                artist_font = "JF Flat 12",
                widget_bg = "#50407800",
                bar_active_color = "#717bf0",
                margin_top=dpi(20),
                forced_width = dpi(816),
                forced_height = dpi(160),
                bar_color = "#cbc1f0"
            }

            s.music2 =
                require("widget.desktop-music") {
                widget_bg = "#00000000",
                widget_title_fg = beautiful.accent,
                widget_artist_fg = beautiful.accent,
                forced_width = dpi(790),
                title_forced_width = dpi(790),
                artist_forced_width = dpi(790),
                forced_height = dpi(200),
                title_font = "JF Flat 20",
                artist_font = "JF Flat 16",
                point = function(geo, args)
                    return {
                        x = 0,
                        y = args.parent.height - geo.height
                    }
                end
            }

            s.music_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.transparent,
                type = "desktop",
                offset = {y = 10},
                widget = s.music
            }
            awful.placement.top(
                s.music_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(426),
                        bottom = dpi(0),
                        right = dpi(55),
                        left = dpi(0)
                    },
                    parent = s
                }
            )

            -----------
            -- Clock --
            -----------
            s.clock =
                require("widget.desktop-clock") {
                fuzzy_time_text_font = "JF Flat 14",
                fuzzy_time_icon_font = "Font Awesome 5 Free Solid 12",
                day_number_text_font = "Poiret One 46",
                month_name_text_font = "JF Flat 21",
                time_now_text_font = "JF Flat 16",
                day_text_font = "JF Flat 21",
                line_margin_right = dpi(10),
                line_margin_left = dpi(10),
                day_align = "left",
                fuzzy_time_offset = 15,
                time_now_top = dpi(7),
                clock_forced_width = dpi(250)
            }

            s.clock_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = "#00000000",
                type = "desktop",
                offset = {y = 10},
                widget = s.clock
            }

            awful.placement.bottom_left(
                s.clock_popup,
                {
                    margins = {
                        top = dpi(0),
                        bottom = dpi(220),
                        right = dpi(0),
                        -- left = dpi(1000)
                        left = dpi(0)
                    },
                    parent = s
                }
            )
        end
    end
)
