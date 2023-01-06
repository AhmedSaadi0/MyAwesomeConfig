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
                line_margin_right = dpi(10),
                line_margin_left = dpi(10),
                day_text_color = "#ffdad9",
                time_now_text_color = "#ffdad9",
                fuzzy_time_fg_color = "#ffdad9",
                month_name_text_color = "#ffdad9",
                day_number_text_color = "#ffdad9",
                day_text_font = "JF Flat 20",
                date_width=dpi(300),
                time_now_top = dpi(8),
                clock_bg = "#4b5569",
                clock_shape = helpers.rrect(100),
                clock_right = dpi(40),
                clock_top = dpi(10),
                clock_bottom = dpi(20),
                separate_line = 0,
                date_bg = "#775653",
                date_shape = helpers.rrect(100),
                date_right = dpi(20),
                date_left = dpi(20),
                date_top = dpi(10),
                date_bottom = dpi(10),
                forced_width = dpi(450)
            }

            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15",
                allow_scroll = true,
                valign = "top"
            }

            s.music2 =
                require("widget.music") {
                widget_fg = "#ffdad9",
                text_font = "JF Flat 15",
                artist_font = "JF Flat 12",
                widget_bg = "#00000000",
                bar_active_color = "#ffdad900",
                margin_top = dpi(15),
                bar_color = "#ffdad900"
            }

            s.final =
                wibox.widget {
                layout = wibox.layout.fixed.vertical,
                ----------
                -- الساعة --
                ----------
                helpers.set_widget_block {
                    widget = s.clock,
                    bg = beautiful.transparent,
                    bottom = dpi(10),
                    margin_bottom = dpi(10)
                },
                ------------
                -- الموسيقى --
                ------------
                helpers.set_widget_block {
                    widget = s.music2,
                    bg = "#595380",
                    shape = helpers.rrect(100),
                    right = dpi(30),
                    margin_right = dpi(0),
                    left = dpi(30),
                    bottom = -5,
                    top = dpi(11),
                    forced_width = dpi(0)
                },
                ----------
                -- الحكم --
                ----------
                helpers.set_widget_block {
                    widget = {
                        layout = wibox.layout.manual,
                        {
                            point = function(geo, args)
                                return {
                                    x = args.parent.width - geo.width,
                                    y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                                }
                            end,
                            helpers.set_widget_block {
                                widget = s.saying,
                                -- bg = "#dcbcbb",
                                fg = "#4b5569",   
                                right = dpi(30),
                                left = dpi(30),
                            },
                            layout = wibox.layout.fixed.vertical
                        }
                    },
                    shape = helpers.rrect(50),
                    -- bg = "#dcbcbb",
                    margin_top = dpi(25),
                    top = dpi(0),
                    bottom = dpi(0),
                    forced_width = dpi(0),
                    forced_height = dpi(80)
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
                        top = dpi(90),
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
