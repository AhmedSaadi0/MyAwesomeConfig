------------------------
-- Dark awesome theme --
------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shape = require("gears.shape")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local gears = require("gears")

local theme = {}

local controllers = require("themes.controllers")

local helpers = require("themes.helpers")

-------------------------------
------------ Fonts ------------
-------------------------------
theme.font = "JF Flat 11"
theme.uifont = "JF Flat 11"
theme.font_n = "Google Sana "
-- notifications
theme.appname_font = "JF Flat Bold 12"
theme.title_font = "JF Flat Bold 12"
theme.message_font = theme.uifont
theme.hotkeys_font = theme.uifont

-- theme.widget_font = "Font Awesome 5 Free Solid 11"
theme.widget_font = theme.uifont
theme.iconfont = "Font Awesome 5 Free Solid 11"

-------------------------------
------------ Colors -----------
-------------------------------
theme.accent =
    helpers.create_gradient_color {
    color1 = "#61afef",
    color2 = "#0cdfff",
    from = {100, 0},
    to = {10, 10}
}
local bar_color =
    helpers.create_gradient_color {
    color2 = "#2a4e6a",
    color1 = "#2a4235",
    from = {0, 0},
    to = {100, 100}
}

local bar_active_color =
    helpers.create_gradient_color {
    color2 = "#61afef",
    color1 = "#a1fdcd",
    from = {0, 0},
    to = {100, 100}
}

theme.bg_normal = "#1c2027"
theme.widget_bg = "#13161b"
theme.bg_focus = "#13161b"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#c8ccd4"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(5)
theme.border_width = controllers.border_width
theme.border_normal = "#00000000"
theme.border_focus = "#a9b1d6"
theme.border_marked = "#7ec7a2"

-- colors
theme.power_button_color = "#fedb41"
theme.taglist_color = "#61afef"

theme.keyboard_layout_color = theme.widget_bg
theme.keyboard_icon_bg_color = "#61afef"
theme.keyboard_icon_fg_color = theme.keyboard_layout_color
theme.keyboard_text_color = theme.keyboard_icon_bg_color

theme.cpu_color = "#f47680"
theme.cpu_icon_bg_color = theme.cpu_color

theme.cpu_temp_color = theme.widget_bg
theme.cpu_temp_icon_bg_color = "#61afef" -- theme.widget_bg
theme.cpu_temp_icon_high_bg_color = "#f9ab5d" -- theme.widget_bg
theme.cpu_temp_icon_fg_color = theme.cpu_temp_color
theme.cpu_temp_text_color = theme.cpu_temp_icon_bg_color

theme.net_speed_color = theme.widget_bg
theme.net_speed_icon_bg_color = theme.cpu_color -- theme.widget_bg
theme.net_speed_icon_fg_color = theme.net_speed_color
theme.net_speed_text_color = theme.net_speed_icon_bg_color

theme.brightness_cr_color = theme.widget_bg
theme.brightness_icon_bg_color = "#7ec7a2" -- theme.widget_bg
theme.brightness_icon_fg_color = theme.brightness_cr_color
theme.brightness_cr_text_color = theme.brightness_icon_bg_color

theme.volume_widget_color = theme.widget_bg
theme.volume_icon_bg_color = "#e5c07b" -- "#ffaaff"
theme.volume_icon_fg_color = theme.volume_widget_color
theme.volume_widget_text_color = theme.volume_icon_bg_color

theme.battery_color = theme.widget_bg
theme.battery_icon_bg_color = "#ffaf5f" -- theme.widget_bg
theme.battery_icon_fg_color = theme.battery_color
theme.battery_text_color = theme.battery_icon_bg_color
theme.battery_hover_color = theme.battery_color

theme.weather_color = theme.widget_bg
theme.weather_icon_bg_color = "#c8ccd4"
theme.weather_icon_fg_color = theme.weather_color
theme.weather_text_color = theme.weather_icon_bg_color

theme.prayer_times_color = theme.widget_bg
theme.prayer_times_icon_bg_color = "#50a285"
theme.prayer_times_text_color = theme.prayer_times_icon_bg_color
theme.prayer_times_icon_fg_color = theme.widget_bg
theme.prayer_times_inner_text_color = theme.widget_bg

theme.clock_color = theme.widget_bg
theme.clock_icon_bg_color = theme.accent
theme.clock_icon_fg_color = theme.clock_color
theme.clock_text_color = theme.clock_icon_bg_color

theme.dashboard_box_bg = theme.widget_bg
theme.dashboard_box_fg = theme.fg_normal
theme.xcolor2 = theme.fg_normal
theme.xforeground = theme.fg_normal

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- Allow desktop widgets
theme.circle_theme = true

--------------------------------
------------ Taglist -----------
--------------------------------
theme.taglist_fg_focus = "#61afef"
theme.taglist_bg_focus = theme.widget_bg

theme.taglist_fg_urgent = "#e06c75"
theme.taglist_bg_urgent = theme.widget_bg

theme.taglist_fg_occupied = "#7ec7a2"
theme.taglist_bg_occupied = theme.widget_bg

theme.taglist_fg_empty = "#545862"
theme.taglist_bg_empty = theme.widget_bg

-- theme.taglist_shape = shape.rectangle -- rounded_bar
theme.taglist_font = theme.iconfont

-- Sys tray
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = controllers.systray_icon_spacing
theme.systray_max_rows = controllers.systray_max_rows

-- Panal
theme.panal_hight = controllers.panal_hight
theme.panal_border_width = controllers.panal_border_width
-- درجة دوران حواف بعض الاشياء مثل الاشعارات واشعار الصوت والسطوع
theme.groups_radius = controllers.groups_radius

-- Control Panal
-- theme.control_panal_hight = dpi(750) -- normal layout
theme.control_panal_hight = controllers.control_panal_hight
theme.control_border_width = controllers.control_border_width
theme.control_border_color = theme.border_focus

-- حواف حول اضافات الاشعارات
theme.slider_inner_border_color = theme.border_focus
theme.slider_inner_border_width = controllers.slider_inner_border_width

-- خلفية ولون اضافات الاشعارات
theme.groups_title_bg = theme.widget_bg
theme.groups_bg = theme.widget_bg
theme.background = theme.bg_normal

theme.transparent = "#00000000"

theme.media_button_color = theme.accent

-- widgets
-- لعمل حواف مستديرة في الاضافات على الشريط العلوي
theme.widgets_corner_radius = theme.groups_radius

-- لون وخصائص شريط تعديل الاضاءة والصوت في الاشعارات --
theme.bar_active_color = "#7ec7a2"
theme.bar_color = "#203f55"
theme.bar_handle_color = theme.accent
theme.bar_handle_border_color = theme.bar_active_color
theme.bar_height = controllers.bar_height
theme.bar_handle_width = controllers.bar_handle_width
theme.bar_handle_border_width = controllers.bar_handle_border_width
theme.bar_shape = controllers.bar_shape

-- لون وخصائص شريط عرض المعالج والرام في الاشعارات
theme.slider_color = bar_active_color
theme.slider_background_color = bar_color
theme.slider_forced_height = controllers.slider_forced_height
theme.slider_shape = controllers.slider_shape
theme.slider_bar_shape = controllers.slider_bar_shape

-- Volume & Brightness widget
theme.vol_bar_active_color = "#7ec7a2"
theme.vol_bar_color = "#203f55"
theme.vol_bar_handle_color = theme.accent
theme.vol_handle_border_color = theme.vol_bar_active_color
theme.vol_bar_height = controllers.vol_bar_height
theme.vol_handle_width = controllers.vol_handle_width
theme.vol_handle_border_width = controllers.vol_handle_border_width
theme.vol_bar_shape = theme.bar_shape

theme.osd_height = controllers.osd_height
theme.osd_width = controllers.osd_width
theme.osd_margin = controllers.osd_margin
theme.osd_handle_shape = controllers.osd_handle_shape

-- Widget
theme.widget_height = controllers.widget_height

-- Generate taglist squares:
local taglist_square_size = controllers.taglist_square_size

-- Decorations
theme.client_shape_rectangle = controllers.client_shape_rectangle
theme.client_shape_rounded = controllers.client_shape_rounded

theme.power_button_shape = controllers.power_button_shape

-- Variables set for theming notifications:
theme.notification_title_margin = controllers.notification_title_margin
theme.notification_body_left_margin = controllers.notification_body_left_margin
theme.notification_body_right_margin = controllers.notification_body_right_margin
theme.notification_body_top_margin = controllers.notification_body_top_margin
theme.notification_body_bottom_margin = controllers.notification_body_bottom_margin
theme.notification_body_margins = controllers.notification_body_margins
-- theme.notification_margins = dpi(60)

theme.critical_notification_bg = "#ff5558"
theme.critical_notification_fg = "#011426"

theme.notification_icon_margin = controllers.notification_icon_margin
theme.notification_bg = theme.bg_normal
theme.notification_border_focus = theme.border_focus
theme.osd_border_width = controllers.osd_border_width
theme.notification_spacing = controllers.notification_spacing

theme.center_notification_border_focus = theme.border_focus
theme.center_notification_border_width = controllers.center_notification_border_width

theme.lock_bg = theme.bg_normal .. "77"
theme.power_button_bg = theme.widget_bg .. "aa"

theme.header_bg = theme.widget_bg
theme.inner_bg = theme.widget_bg

theme.notification_center_header_bg = theme.header_bg
theme.notification_center_inner_bg = theme.inner_bg

theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = controllers.menu_height
theme.menu_width = controllers.menu_width

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
-- theme.wallpaper = "~/.config/awesome/themes/wallpapers/circles-wallpaper.png"
theme.wallpaper = "~/.config/awesome/themes/wallpapers/wall_arch.png"

theme.music_back = "~/.config/awesome/themes/assets/no_music.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = nil
theme.icons = require("themes.icons-circles-gradients")

theme.dynamic_wallpaper_dir = "themes/wallpapers//"
theme.conky_script = "/themes/conky/conky-circles.sh"

theme.kvantum_theme = "a-circles"
theme.konsole_profile = "--profile Circles"
-- theme.qt_icon_theme = "FairyWren" --"Calm"
theme.qt_icon_theme = "oomox-aesthetic-dark"

-- theme.qt_style_theme = "Breeze"
theme.qt_style_theme = "Breeze"
-- theme.gtk_theme = "Flat-Remix-GTK-Blue-Dark-Solid"
theme.gtk_theme = "Tokyonight-Dark-B-LB"

theme.plasma_cursors = "GoogleDot-Black"
theme.plasma_color = "Circles"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
