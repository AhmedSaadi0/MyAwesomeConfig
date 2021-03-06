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

-------------------------------
------------ Fonts ------------
-------------------------------
theme.font = "JF Flat 11"
theme.uifont = "JF Flat 11"
theme.font_n = "Google Sana "
-- notifications
theme.appname_font = "Google Sana 10"
theme.title_font = "Google Sana 11"
theme.message_font = theme.uifont

-- theme.widget_font = "Font Awesome 5 Free Solid 11"
theme.widget_font = theme.uifont
theme.iconfont = "Font Awesome 5 Free Solid 11"

theme.accent = "#f882b2"

-------------------------------
------------ Colors -----------
-------------------------------
theme.bg_normal = "#211040" .. "99"
theme.widget_bg = "#1a0d33" .. "99"
theme.bg_focus = "#16161e"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#92a0bd"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_normal = "#703763"
theme.border_focus = theme.accent
theme.border_marked = "#7ec7a2"

theme.widget_text_color = "#111b34"
-- colors
theme.power_button_color = "#fedb41"
theme.taglist_color = "#a4dfff"

theme.keyboard_layout_color = "#aa55ff"
theme.keyboard_icon_bg_color = "#8744cb" -- "#aaaaff"
theme.keyboard_icon_fg_color = theme.widget_text_color -- "#aaaaff"
theme.keyboard_text_color = theme.widget_text_color -- "#aaaaff"

theme.cpu_color = "#ff79c6"
theme.cpu_icon_color = "#5e81ac" --"#ff79c6"

theme.net_speed_color = "#a95292"
theme.net_speed_icon_bg_color = "#8f467d" -- "#00efd1"
theme.net_speed_icon_fg_color = theme.widget_text_color
theme.net_speed_text_color = theme.net_speed_icon_fg_color

theme.brightness_cr_color = "#7aa2f7"
theme.brightness_icon_bg_color = "#668ee3" -- "#ffaaff"
theme.brightness_icon_fg_color = theme.widget_text_color
theme.brightness_cr_text_color = theme.brightness_icon_fg_color

theme.battery_color = "#7ec7a1"
theme.battery_icon_bg_color = "#6dac8a" -- "#ffaf5f"
theme.battery_icon_fg_color = theme.widget_text_color
theme.battery_text_color = theme.battery_icon_fg_color
theme.battery_hover_color = "#67a383" -- "#ffaf5f"

theme.clock_color = theme.widget_text_color 
theme.clock_icon_bg_color = "#e1d7be" -- "#b1a151"
theme.clock_icon_fg_color = theme.widget_text_color
theme.clock_text_color = theme.clock_icon_bg_color 

theme.dashboard_box_bg = theme.widget_text_color
theme.dashboard_box_fg = theme.fg_normal
theme.xcolor2 = theme.fg_normal
theme.xforeground = theme.fg_normal

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

--------------------------------
------------ Taglist -----------
--------------------------------
-- TAG List
theme.taglist_fg_focus = theme.accent
theme.taglist_bg_focus = theme.widget_bg

theme.taglist_fg_urgent = "#e06c75"
theme.taglist_bg_urgent = theme.widget_bg

theme.taglist_fg_occupied = "#6dab89"
theme.taglist_bg_occupied = theme.widget_bg

theme.taglist_fg_empty = "#545862"
theme.taglist_bg_empty = theme.widget_bg

-- theme.taglist_shape = shape.rectangle -- rounded_bar
theme.taglist_font = theme.iconfont


-- theme.taglist_shape = shape.rectangle -- rounded_bar
-- TAG List
-- theme.taglist_fg_focus = theme.accent
-- theme.taglist_bg_focus = "#2e3440"
-- theme.taglist_bg_urgent = "#e06c75"
-- theme.taglist_fg_occupied = "#ffaa7f"
-- theme.taglist_bg_occupied = theme.widget_bg
-- theme.taglist_bg_empty = theme.widget_bg
-- theme.taglist_font = theme.iconfont

-- Sys tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)
theme.systray_max_rows = dpi(1)

-- Panal
theme.panal_hight = dpi(32)
theme.panal_border_width = dpi(0)
theme.groups_radius = dpi(12)

-- Control Panal and notification panal
theme.control_panal_hight = dpi(880)
theme.control_border_width = dpi(0)
theme.control_border_color = "#ffffff"
-- Control panal widgets

theme.slider_inner_border_color = "#458588"
theme.slider_inner_border_width = dpi(0)

theme.groups_title_bg = theme.widget_bg
theme.groups_bg = theme.widget_bg
theme.background = theme.bg_normal

theme.transparent = "#00000000"

theme.media_button_color = theme.accent

-- widgets --
-- ???????? ???????? ?????????????? ???? ???????????????? ?????? ???????????? ????????????
theme.widgets_corner_radius = dpi(15)

-- ???????????????? ??????????????
theme.bar_active_color = theme.accent
theme.bar_color = theme.bar_active_color .. "30"
theme.bar_handle_color = theme.bar_active_color
theme.bar_handle_border_color = theme.widget_bg
theme.bar_height = dpi(1)
theme.bar_handle_width = dpi(10)
theme.bar_handle_border_width = dpi(0)
theme.bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 30)
end
-- ?????????????? ??????????????
theme.slider_color = theme.accent
theme.slider_background_color = theme.slider_color .. "30"
theme.slider_forced_height = dpi(1)


-- Volume & Brightness widget
theme.vol_bar_active_color = theme.accent
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
theme.notification_bg = theme.bg_normal
theme.notification_border_focus = theme.border_focus
theme.osd_border_width = dpi(0)
theme.notification_spacing = dpi(25)

theme.center_notification_border_focus = theme.widget_bg
theme.center_notification_border_width = dpi(0)

theme.lock_bg = theme.widget_bg

theme.header_bg = theme.widget_bg
theme.inner_bg = theme.widget_bg

theme.notification_center_header_bg = theme.widget_bg
theme.notification_center_inner_bg = theme.widget_bg

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

theme.wallpaper = "~/.config/awesome/themes/wallpapers/pinky-wallpaper.jpg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
theme.icons = require("themes.icons-pinky")
theme.dynamic_wallpaper_dir = "themes/wallpapers//"
theme.conky_script = "/configuration/conky-dark.sh"
theme.kvantum_theme = "ArcMidnight-dark"
theme.konsole_profile = "--profile pinky"

theme.light_theme = "light_theme"
theme.dark_theme = "pinky_theme"

theme.plasma_cursors = "ArcStarry-cursors"
theme.plasma_color = "ArcAuroraDark.colors"

return theme
