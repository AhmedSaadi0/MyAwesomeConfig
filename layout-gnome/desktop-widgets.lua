local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

awful.screen.connect_for_each_screen(
    function(s)
        if beautiful.desktop_music_widget then
            s.music =
                require("widget.desktop-music") {
                widget_bg = "00000000",
                widget_artist_fg = beautiful.widget_artist_fg or beautiful.desktop_music_widget_fg,
                widget_title_fg = beautiful.widget_title_fg or beautiful.desktop_music_widget_fg,
                forced_width = beautiful.desktop_music_widget_maximum_width,
                title_font = beautiful.desktop_music_widget_title_font or "JF Flat 20",
                artist_font = beautiful.desktop_music_widget_artist_font or "JF Flat 16"
            }

            s.music_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.desktop_music_widget_bg,
                type = "desktop",
                -- shape = shape,
                -- border_width = border_width,
                -- border_color = border_color,
                maximum_width = beautiful.desktop_music_widget_maximum_width,
                offset = {y = 10},
                widget = s.music
            }
            awful.placement.top_left(
                s.music_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = beautiful.desktop_music_widget_top,
                        bottom = beautiful.desktop_music_widget_bottom,
                        right = beautiful.desktop_music_widget_right,
                        left = beautiful.desktop_music_widget_left
                    },
                    parent = s
                }
            )
        end

        if beautiful.desktop_clock_widget then
            s.clock = require("widget.desktop-clock") {}

            s.clock_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.desktop_music_widget_bg,
                type = "desktop",
                -- shape = shape,
                -- border_width = border_width,
                -- border_color = border_color,
                maximum_width = beautiful.desktop_music_widget_maximum_width,
                offset = {y = 10},
                widget = s.clock
            }
            awful.placement.top(
                s.clock_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = beautiful.desktop_clock_widget_top,
                        bottom = beautiful.desktop_clock_widget_bottom,
                        right = beautiful.desktop_clock_widget_right,
                        left = beautiful.desktop_clock_widget_left
                    },
                    parent = s
                }
            )
        end

        if beautiful.desktop_clock_music then
            s.clock = require("widget.desktop-clock") {}

            s.saying =
                require("widget.desktop-saying") {
                wisdom_text_font = "JF Flat 15"
            }

            s.music =
                require("widget.desktop-music") {
                widget_bg = "00000000",
                widget_artist_fg = beautiful.widget_artist_fg or beautiful.desktop_music_widget_fg,
                widget_title_fg = beautiful.widget_title_fg or beautiful.desktop_music_widget_fg,
                title_font = beautiful.desktop_music_widget_title_font or "JF Flat 20",
                artist_font = beautiful.desktop_music_widget_artist_font or "JF Flat 16"
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
                    right = dpi(15),
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
                    left = dpi(15),
                    right = dpi(15),
                    top = dpi(30)
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
                    left = dpi(15),
                    right = dpi(15)
                }
            }

            s.clock_popup =
                awful.popup {
                ontop = false,
                visible = true,
                bg = beautiful.desktop_music_widget_bg,
                type = "desktop",
                -- shape = shape,
                -- border_width = border_width,
                -- border_color = border_color,
                -- maximum_width = beautiful.desktop_music_widget_maximum_width,
                offset = {y = 10},
                widget = s.final
            }
            awful.placement.top_left(
                s.clock_popup,
                {
                    margins = {
                        -- right = panel_margins,
                        top = beautiful.desktop_clock_widget_top,
                        bottom = beautiful.desktop_clock_widget_bottom,
                        right = beautiful.desktop_clock_widget_right,
                        left = beautiful.desktop_clock_widget_left
                    },
                    parent = s
                }
            )
        end
    end
)
