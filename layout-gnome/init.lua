-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
-- require("layout.top-bar")
require("layout-gnome.top-bar")

if beautiful.color_theme then
    require("layout-gnome.desktop-widgets.colors-theme")
elseif beautiful.cosmic_theme then
    require("layout-gnome.desktop-widgets.cosmic-theme")
elseif beautiful.circle_theme then
    require("layout-gnome.desktop-widgets.circles-theme")
elseif beautiful.light_theme_widgets then
    require("layout-gnome.desktop-widgets.light-theme")
elseif beautiful.dark_theme_widgets then
    require("layout-gnome.desktop-widgets.dark-theme")
elseif beautiful.islamic_theme_widgets then
    require("layout-gnome.desktop-widgets.islamic-theme")
end

require ("layout-gnome.control-center")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se
}
-- }}}

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button(
            {},
            3,
            function()
                mymainmenu:toggle()
            end
        ),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
