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
            if beautiful.color_theme then
                s.clock =
                    require("widget.desktop-clock") {
                    month_left = dpi(65),
                    time_right = dpi(10)
                }

                s.saying =
                    require("widget.desktop-saying") {
                    wisdom_text_font = "JF Flat 15",
                    forced_width = dpi(750)
                }

                s.music =
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
                    forced_width = dpi(570),
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

            --------------------------------
            --------- Circle Theme ---------
            --------------------------------
            if beautiful.circle_theme then
                -------------
                -- Wisdoms --
                -------------
                s.saying =
                    require("widget.desktop-saying") {
                    wisdom_text_font = "JF Flat 15",
                    forced_width = dpi(490),
                    forced_height = dpi(170),
                    valign = "top"
                }

                s.saying_popup =
                    awful.popup {
                    ontop = false,
                    visible = true,
                    bg = beautiful.transparent,
                    type = "desktop",
                    forced_width = dpi(490),
                    offset = {y = 10},
                    fg = "#e06c75",
                    widget = s.saying
                }
                awful.placement.bottom_right(
                    s.saying_popup,
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
                -- Music --
                -----------
                s.music =
                    require("widget.desktop-music") {
                    widget_bg = "00000000",
                    widget_title_fg = "#e06c75",
                    widget_artist_fg = "#e06c75",
                    forced_width = dpi(490),
                    title_font = "JF Flat 20",
                    artist_font = "JF Flat 16"
                }

                s.music_popup =
                    awful.popup {
                    ontop = false,
                    visible = true,
                    bg = beautiful.transparent,
                    type = "desktop",
                    forced_width = dpi(490),
                    offset = {y = 10},
                    widget = s.music
                }
                awful.placement.bottom_right(
                    s.music_popup,
                    {
                        margins = {
                            -- right = panel_margins,
                            top = dpi(0),
                            bottom = dpi(240),
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
                awful.placement.top(
                    s.clock_popup,
                    {
                        margins = {
                            -- right = panel_margins,
                            top = dpi(520),
                            bottom = dpi(0),
                            right = dpi(0),
                            left = dpi(-1000)
                        },
                        parent = s
                    }
                )
            end

            --------------------------------
            --------- Light Theme ---------
            --------------------------------
            if beautiful.light_theme_widgets then
                -------------
                -- Wisdoms --
                -------------
                s.saying =
                    require("widget.desktop-saying") {
                    wisdom_text_font = "JF Flat 15",
                    forced_width = dpi(790),
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
                    require("widget.desktop-music") {
                    widget_bg = "00000000",
                    widget_title_fg = beautiful.accent,
                    widget_artist_fg = beautiful.accent,
                    forced_width = dpi(790),
                    title_font = "JF Flat 20",
                    artist_font = "JF Flat 16"
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
                            top = dpi(510),
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
                s.clock = require("widget.desktop-clock") {
                    fuzzy_time_text_font = "JF Flat 14",
                    fuzzy_time_icon_font = "Font Awesome 5 Free Solid 12",
                    day_number_text_font = "JF Flat 46",
                    month_name_text_font = "JF Flat 21",
                    time_now_text_font = "JF Flat 16",
                    day_text_font = "JF Flat 21",
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
    end
)
