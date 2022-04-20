-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- themes handling library
local beautiful = require("beautiful")

-- Widget library
local wibox = require("wibox")

-- Helpers
local helpers = require("helpers")

local dpi = beautiful.xresources.apply_dpi
local mediakeys = require("widget.music.mediakeys")

-- Music
----------

local music_text =
    wibox.widget {
    font = beautiful.uifont .. "medium 8",
    valign = "center",
    widget = wibox.widget.textbox
}

local music_art =
    wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "themes/assets/no_music.png",
    resize = true,
    widget = wibox.widget.imagebox
}

local music_art_container =
    wibox.widget {
    music_art,
    forced_height = dpi(120),
    forced_width = dpi(120),
    widget = wibox.container.background
}

local filter_color = {
    type = "linear",
    from = {0, 0},
    to = {0, 120},
    stops = {
        {0, beautiful.notification_center_inner_bg .. "55"},
        {1, beautiful.notification_center_inner_bg}
    }
}

local music_art_filter =
    wibox.widget {
    {
        bg = filter_color,
        forced_height = dpi(120),
        forced_width = dpi(120),
        widget = wibox.container.background
    },
    direction = "east",
    widget = wibox.container.rotate
}

local music_title =
    wibox.widget {
    font = beautiful.uifont .. "medium 9",
    valign = "right",
    widget = wibox.widget.textbox
}

local music_artist =
    wibox.widget {
    font = beautiful.uifont .. "medium 12",
    valign = "right",
    widget = wibox.widget.textbox
}

local music_pos =
    wibox.widget {
    font = beautiful.uifont .. "medium 8",
    valign = "right",
    widget = wibox.widget.textbox
}

-- playerctl
---------------

local playerctl = require("module.bling").signal.playerctl.lib()

playerctl:connect_signal(
    "metadata",
    function(_, title, artist, album_path, __, ___, ____)
        if title == "" then
            title = "لم يتم تشغيل اي شيء"
        end
        if artist == "" then
            artist = "لا يوجد فنان"
        end
        if album_path == "" then
            album_path = gears.filesystem.get_configuration_dir() .. "themes/assets/no_music.png"
        end

        music_art:set_image(gears.surface.load_uncached(album_path))
        music_title:set_markup_silently(helpers.colorize_text(title, beautiful.xforeground .. "b3"))
        music_artist:set_markup_silently(helpers.colorize_text(artist, beautiful.xforeground .. "e6"))
    end
)

playerctl:connect_signal(
    "playback_status",
    function(_, playing, __)
        if playing then
            music_text:set_markup_silently(helpers.colorize_text("يتم تشغيل", beautiful.xforeground .. "cc"))
        else
            music_text:set_markup_silently(helpers.colorize_text("الموسيقى", beautiful.xforeground .. "cc"))
        end
    end
)

playerctl:connect_signal(
    "position",
    function(_, interval_sec, length_sec, player_name)
        local pos_now = tostring(os.date("!%M:%S", math.floor(interval_sec)))
        local pos_length = tostring(os.date("!%M:%S", math.floor(length_sec)))
        local pos_markup = helpers.colorize_text(pos_now .. " / " .. pos_length, beautiful.xforeground .. "66")

        music_pos:set_markup_silently(pos_markup)
    end
)

local music =
    wibox.widget {
    {
        {
            {
                -- mediakeys,
                music_art_container,
                layout = wibox.layout.align.vertical
                -- music_art_filter,
            },
            {
                {
                    music_text,
                    {
                        {
                            {
                                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                speed = 50,
                                {
                                    widget = music_artist
                                },
                                widget = wibox.container.scroll.horizontal
                            },
                            {
                                step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
                                speed = 50,
                                {
                                    widget = music_title
                                },
                                widget = wibox.container.scroll.horizontal
                            },
                            -- music_artist,
                            -- music_title,
                            mediakeys,
                            layout = wibox.layout.fixed.vertical
                        },
                        -- bottom = dpi(15),
                        widget = wibox.container.margin
                    },
                    music_pos,
                    expand = "none",
                    layout = wibox.layout.align.vertical
                },
                top = dpi(9),
                bottom = dpi(9),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal
        },
        bg = beautiful.notification_center_inner_bg,
        shape = helpers.rrect(dpi(5)),
        -- forced_width = dpi(350),
        forced_height = dpi(120),
        widget = wibox.container.background
    },
    -- top = dpi(9),
    -- bottom = dpi(9),
    widget = wibox.container.margin
}

return music
