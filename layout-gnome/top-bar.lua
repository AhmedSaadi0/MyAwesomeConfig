local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = require("beautiful").xresources.apply_dpi

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local my_text_clock =
    wibox.widget {
    format = "(%I:%M) %A, %d %B",
    valign = "center",
    align = "center",
    widget = wibox.widget.textclock
}

local clock_icon = helpers.add_text("", beautiful.clock_icon_fg_color)

my_text_clock:connect_signal(
    "button::press",
    function()
        local focused = awful.screen.focused()
        focused.central_panel:toggle()
    end
)

clock_icon:connect_signal(
    "button::press",
    function()
        local focused = awful.screen.focused()
        focused.central_panel:toggle()
    end
)

-- Create a wibox for each screen and add it
local taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(t)
            t:view_only()
        end
    ),
    awful.button(
        {modkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button(
        {modkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    )
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        -- Wallpaper
        set_wallpaper(s)

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()

        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    3,
                    function()
                        awful.layout.inc(-1)
                    end
                ),
                awful.button(
                    {},
                    4,
                    function()
                        awful.layout.inc(1)
                    end
                ),
                awful.button(
                    {},
                    5,
                    function()
                        awful.layout.inc(-1)
                    end
                )
            )
        )
        -- Create a taglist widget
        s.mytaglist =
            awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
            layout = {
                spacing = 0,
                spacing_widget = {
                    color = beautiful.taglist_color
                    -- shape  = gears.shape.powerline,
                    -- widget = wibox.widget.separator,
                },
                layout = wibox.layout.fixed.horizontal
            },
            widget_template = {
                {
                    {
                        {
                            {
                                id = "icon_role",
                                widget = wibox.widget.imagebox
                            },
                            margins = 0,
                            widget = wibox.container.margin
                        },
                        {
                            id = "text_role",
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.horizontal
                    },
                    left = 8,
                    right = 8,
                    widget = wibox.container.margin
                },
                id = "background_role",
                widget = wibox.container.background
            }
        }

        s.mywibox =
            awful.wibar(
            {
                position = "top",
                screen = s,
                type = "panel",
                height = beautiful.panal_hight,
                border_width = beautiful.panal_border_width,
                border_color = beautiful.bg_normal
            }
        )

        s.systray =
            wibox.widget {
            visible = false,
            base_size = 22,
            horizontal = true,
            screen = "primary",
            widget = wibox.widget.systray
        }

        s.tray_toggler = require("widget.tray-toggle")

        s.cpu =
            require("widget.cpu")(
            {
                width = 90,
                step_width = 2,
                step_spacing = 0,
                color = beautiful.cpu_color,
                enable_kill_button = true
            }
        )
        s.ns =
            require("widget.net-speed-widget") {
            timeout = 0.1,
            width = 60
        }
        s.brightness = require("widget.brightness-widget") {}
        s.volume = require("widget.volume-widget.init") {}
        s.bat = require("widget.battery.init")()

        s.temp =
            require("widget.temp") {
            tooltip_border_color = beautiful.cpu_temp_color
            -- tooltip_bg = beautiful.cpu_temp_color,
            -- tooltip_fg = beautiful.cpu_temp_icon_fg_color,
        }
        s.weather =
            require("widget.wttr-weather") {
            widget_bg = beautiful.weather_color,
            widget_fg = beautiful.weather_text_color
            -- city = "Cairo",
        }

        s.left_menu = require("layout-gnome.left_menu") {}

        s.mywibox:setup {
            layout = wibox.layout.manual,
            --------------------------------
            --------- Left widgets ---------
            --------------------------------
            {
                point = function(geo, args)
                    return {
                        x = 0,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end,
                layout = wibox.layout.fixed.horizontal,
                -----------
                -- Power --
                -----------
                helpers.set_widget_block {
                    widget = s.left_menu,
                    left = dpi(12),
                    right = dpi(12),
                    bg = beautiful.bg_normal,
                    fg = beautiful.fg_normal,
                },
                helpers.set_space(6),
                -------------
                -- Systray --
                -------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.systray,
                        bg = beautiful.transparent,
                        left = 2,
                        right = 2
                    },
                    bg = beautiful.transparent,
                    top = 4
                    -- bottom = 4
                },
                s.tray_toggler,
                helpers.set_space(6),
                ---------------------
                -- keyboard layout --
                ---------------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = mykeyboardlayout,
                        bg = beautiful.keyboard_layout_color,
                        fg = beautiful.keyboard_text_color,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        left = 2,
                        right = 2
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.keyboard_icon_fg_color),
                        bg = beautiful.keyboard_icon_bg_color,
                        font = beautiful.iconfont,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        right = 5,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    font = beautiful.iconfont,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                ---------------
                -- Net speed --
                ---------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.ns,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        bg = beautiful.net_speed_color,
                        fg = beautiful.net_speed_text_color,
                        left = 5,
                        right = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.net_speed_icon_fg_color),
                        bg = beautiful.net_speed_icon_bg_color,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        right = 7,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                ------------
                -- Volume --
                ------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.volume,
                        bg = beautiful.volume_widget_color,
                        fg = beautiful.volume_widget_text_color,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        left = 7,
                        right = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.volume_icon_fg_color),
                        bg = beautiful.volume_icon_bg_color,
                        right = 5,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        font = beautiful.iconfont,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                ----------------
                -- Brightness --
                ----------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.brightness,
                        bg = beautiful.brightness_cr_color,
                        fg = beautiful.brightness_cr_text_color,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        left = 7,
                        right = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.brightness_icon_fg_color),
                        bg = beautiful.brightness_icon_bg_color,
                        right = 5,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        font = beautiful.iconfont,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                -------------
                -- Weather --
                -------------
                helpers.set_widget_block {
                    widget = s.weather,
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                }
            },
            ---------------------------------
            --------- Middle widgets ---------
            ---------------------------------
            {
                -- Clock widget
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = {
                            helpers.set_widget_block {
                                widget = helpers.set_widget_block {
                                    widget = my_text_clock,
                                    bg = beautiful.clock_color,
                                    fg = beautiful.clock_text_color,
                                    shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                                    top = 3,
                                    bottom = 3,
                                    left = 10,
                                    right = 10
                                },
                                bg = beautiful.transparent,
                                top = 1,
                                bottom = 1
                            },
                            helpers.set_widget_block {
                                widget = clock_icon,
                                bg = beautiful.clock_icon_bg_color,
                                shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                                font = "Font Awesome 5 Free Solid 11",
                                right = 10,
                                left = 7
                            },
                            layout = wibox.layout.fixed.horizontal
                        },
                        bg = beautiful.clock_color,
                        shape = helpers.rrect(beautiful.widgets_corner_radius)
                    },
                    bg = beautiful.transparent,
                    top = 0,
                    bottom = 0
                },
                widget = wibox.container.background,
                point = function(geo, args)
                    return {
                        x = (args.parent.width / 2 + (geo.width / 2)) - geo.width,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end
            },
            ---------------------------------
            --------- Right widgets ---------
            ---------------------------------
            {
                point = function(geo, args)
                    return {
                        x = args.parent.width - geo.width,
                        y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
                    }
                end,
                layout = wibox.layout.fixed.horizontal,
                -------------
                -- Battery --
                -------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.bat,
                        bg = beautiful.battery_color,
                        fg = beautiful.battery_text_color,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        left = 3,
                        right = 3
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.battery_icon_fg_color, "Font Awesome 5 Free Solid 11"),
                        bg = beautiful.battery_icon_bg_color,
                        right = 8,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        left = 8
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                --------------
                -- CPU TEMP --
                --------------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.temp,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius),
                        bg = beautiful.cpu_temp_color,
                        fg = beautiful.cpu_temp_text_color,
                        left = 5,
                        right = 5
                    },
                    top = 4,
                    bottom = 4,
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.cpu_temp_icon_fg_color),
                        bg = beautiful.cpu_temp_icon_bg_color,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        right = 7,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                ---------
                -- CPU --
                ---------
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.cpu,
                        shape = helpers.left_rounded_rect(beautiful.widgets_corner_radius)
                    },
                    top = 4,
                    bottom = 4,
                    bg = beautiful.transparent
                },
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = helpers.add_text("", beautiful.cpu_color),
                        bg = beautiful.widget_bg,
                        shape = helpers.right_rounded_rect(beautiful.widgets_corner_radius),
                        font = "Font Awesome 5 Free Solid 11",
                        right = 10,
                        left = 5
                    },
                    bg = beautiful.transparent,
                    top = 4,
                    bottom = 4
                },
                helpers.set_space(7),
                helpers.set_widget_block {
                    widget = helpers.set_widget_block {
                        widget = s.mytaglist,
                        shape = helpers.rrect(beautiful.widgets_corner_radius)
                    },
                    top = 4,
                    bottom = 4,
                    bg = beautiful.transparent
                },
                -- s.mypromptbox,
                helpers.set_space(7),
                helpers.set_widget_block {
                    widget = s.mylayoutbox,
                    top = 4,
                    bottom = 4,
                    bg = beautiful.transparent
                }
            }
        }
    end
)
-- }}}
