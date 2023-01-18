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
                forced_width = dpi(500),
                forced_height = dpi(300),
                valign = "top"
            }

            -----------
            -- Music --
            -----------
            s.music2 =
                require("widget.music") {
                widget_fg = beautiful.accent,
                widget_bg = "#1c1d29",
                text_font = "JF Flat 15",
                artist_font = "JF Flat 12",
                margin_top=dpi(15),
                forced_height = dpi(160),
                bar_active_color = "#edcc3d",
                bar_color = "#edcc3d55"
            }
            s.music =
                require("widget.desktop-music") {
                widget_bg = "#00000000",
                widget_title_fg = beautiful.accent,
                widget_artist_fg = beautiful.accent,
                forced_width = dpi(500),
                title_forced_width = dpi(550),
                artist_forced_width = dpi(550),
                forced_height = dpi(70),
                title_font = "VIP Rawy Regular 20",
                artist_font = "JF Flat 16",
                point = function(geo, args)
                    return {
                        x = args.parent.width - geo.width,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end
            }

            s.final =
                wibox.widget {
                layout = wibox.layout.fixed.vertical,
                forced_width = dpi(500),
                ----------------
                -- الفاصل العرضي --
                ----------------
                helpers.set_widget_block {
                    widget = {
                        text = "",
                        widget = wibox.widget.textbox
                    },
                    shape = gears.shape.rectangle,
                    bg = "#edcc3d",
                    fg = "#edcc3d",
                    top = dpi(2),
                    margin_top = dpi(10),
                    margin_left = dpi(13),
                    margin_right = dpi(13),
                },
                ------------
                -- الموسيقى --
                ------------
                helpers.set_widget_block {
                    widget = s.music2,
                    bg = "#00000000",
                    bottom = dpi(10),
                    top = dpi(10)
                },
                ----------
                -- الحكم --
                ----------
                helpers.set_widget_block {
                    widget = s.saying,
                    bg = "#00000000",
                    fg = beautiful.accent,
                    top = dpi(0),
                    right = dpi(13),
                    left = dpi(13),
                }
            }

            s.popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.transparent,
                type = "desktop",
                offset = {y = 10},
                widget = s.final
            }
            awful.placement.bottom(
                s.popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = dpi(0),
                        bottom = 0,
                        right = 0,
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
                fuzzy_time_text_font = "Kufam 14",
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
                clock_forced_width = dpi(250),
                fuzzy_time_fg_color = "#f8d63f"
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
                        bottom = dpi(130),
                        right = dpi(0),
                        -- left = dpi(1000)
                        left = dpi(125)
                    },
                    parent = s
                }
            )
        end
    end
)
