---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shape = require("gears.shape")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears = require("gears")

local theme = {}

theme.font = "JF Flat 11"
theme.font_n = "JF Flat"
theme.uifont = "JF Flat 11"
-- theme.widget_font = "Font Awesome 5 Free Solid 11"
theme.widget_font = theme.uifont
theme.iconfont = theme.uifont

theme.bg_normal = "#1e222a"
theme.widget_bg = "#282a36"
theme.bg_focus = "#282a36"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#92a0bd"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_normal = "#e06c75"
theme.border_focus = "#00efd1"
theme.border_marked = "#7ec7a2"

-- TAG List
theme.taglist_fg_focus = "#86e6fc"
theme.taglist_bg_focus = "#2e3440"
theme.taglist_fg_occupied = "#ff79c6"
theme.taglist_bg_occupied = theme.widget_bg
theme.taglist_bg_empty = theme.widget_bg

-- theme.taglist_shape = shape.rounded_bar
theme.taglist_shape = shape.rectangle
-- theme.taglist_shape_border_width = 0

-- theme.taglist_fg_volatile = ""
-- theme.taglist_fg_empty = "#214f8b"

-- Sys tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)
theme.systray_max_rows = dpi(1)

-- Panal
theme.panal_hight = dpi(22)
theme.panal_border_width = dpi(6)
theme.groups_radius = dpi(12)

-- Control Panal
theme.control_panal_hight = dpi(830)
theme.control_border_width = dpi(0)
theme.control_border_color = dpi(0)
-- Control panal widgets

theme.dashboard_box_bg = theme.widget_bg
theme.dashboard_box_fg = theme.fg_normal
theme.xcolor2 = theme.fg_normal
theme.xforeground = theme.fg_normal

theme.slider_inner_border_color = "#458588"
theme.slider_inner_border_width = dpi(0)

theme.groups_title_bg = theme.widget_bg
theme.groups_bg = theme.widget_bg
theme.background = theme.bg_normal

theme.header_bg = "#23252f"
theme.inner_bg = "#282a36"

theme.notification_center_header_bg = "#23252f"
theme.notification_center_inner_bg = "#282a36"

theme.transparent = "#00000000"

theme.accent = theme.border_focus
theme.media_button_color = "#00efd1"

-- widgets
theme.bar_active_color = "#00efd1"
theme.bar_color = theme.bar_active_color .. "30"
theme.bar_handle_color = theme.bar_active_color
theme.bar_handle_border_color = theme.bar_active_color

theme.slider_color = "#00efd1"
theme.slider_background_color = theme.slider_color .. "30"
theme.slider_forced_height = dpi(1)

theme.bar_height = dpi(1)
theme.bar_handle_width = dpi(10)
theme.bar_handle_border_width = dpi(0)
theme.bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 30)
end

-- Volume & Brightness widget
theme.vol_bar_active_color = "#00efd1"
theme.vol_bar_handle_color = theme.vol_bar_active_color
theme.vol_handle_border_color = theme.vol_bar_active_color
theme.vol_bar_height = dpi(35)
theme.vol_handle_width = dpi(0)
theme.vol_handle_border_width = dpi(0)
theme.vol_bar_color = theme.vol_bar_active_color .. "30"
theme.vol_bar_shape = theme.bar_shape

-- Widget
theme.widget_height = dpi(25)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
theme.notification_title_margin = dpi(6)

theme.notification_body_left_margin = dpi(7)
theme.notification_body_right_margin = dpi(7)
theme.notification_body_top_margin = dpi(8)
theme.notification_body_bottom_margin = dpi(6)
theme.notification_body_margins = dpi(6)
-- theme.notification_margins = dpi(60)

theme.notification_icon_margin = dpi(2)
theme.notification_title_color = "#282a36"
theme.notification_bg = "#21222c"
theme.notification_border_focus = theme.border_focus
theme.notification_border_width = dpi(0)

theme.center_notification_border_focus = theme.border_focus
theme.center_notification_border_width = dpi(0)

theme.lock_bg = "#21222c" .. "77"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/themes/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/themes/layouts/fairvw.png"
theme.layout_floating = "~/.config/awesome/themes/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/themes/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/themes/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/layouts/tilebottomw.png"
theme.layout_tileleft = "~/.config/awesome/themes/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/themes/layouts/tiletopw.png"
theme.layout_spiral = "~/.config/awesome/themes/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/themes/layouts/dwindlew.png"
theme.layout_cornernw = "~/.config/awesome/themes/layouts/cornernww.png"
theme.layout_cornerne = "~/.config/awesome/themes/layouts/cornernew.png"
theme.layout_cornersw = "~/.config/awesome/themes/layouts/cornersww.png"
theme.layout_cornerse = "~/.config/awesome/themes/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
