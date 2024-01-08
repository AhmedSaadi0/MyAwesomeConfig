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

-- theme.accent = "#61afef"
theme.accent =
    helpers.create_gradient_color {
    color1 = "#7666fc",
    color2 = "#fd6cac",
    from = {80, 10},
    to = {-20, 10}
}

theme.bg_normal = "#ffffff"
theme.widget_bg = "#f0f3fa"
theme.bg_focus = "#f0f3fa"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#1f1f1f"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(5)
theme.border_width = controllers.border_width
theme.border_normal = "#00000000"
theme.border_focus = "#8964ea"
theme.border_marked = "#7ec7a2"

-- colors
theme.power_button_color = "#fedb41"
theme.taglist_color = "#8964ea"

theme.keyboard_layout_color =
    helpers.create_gradient_color {
    color1 = "#ee5161",
    color2 = "#8965ea",
    from = {80, 10},
    to = {10, 10}
}
theme.keyboard_icon_bg_color = "#a160ca"
theme.keyboard_icon_fg_color = theme.bg_normal
theme.keyboard_text_color = theme.keyboard_icon_fg_color

theme.cpu_color = "#f47680"
theme.cpu_icon_bg_color = theme.cpu_color

theme.cpu_temp_color = "#00000000"
theme.cpu_temp_whole_color =
    helpers.create_gradient_color {
    color1 = "#ee5161",
    color2 = "#fecca4",
    from = {50, 10},
    to = {-10, 10}
}
theme.cpu_temp_icon_bg_color = theme.cpu_temp_color
theme.cpu_temp_icon_fg_color = theme.bg_normal
theme.cpu_temp_text_color = theme.cpu_temp_icon_fg_color

theme.net_speed_color = "#00000000"
theme.net_speed_whole_color = helpers.create_gradient_color {
    color1 = "#8a64eb",
    color2 = "#75f2e8",
    stops1 = 0,
    stops2 = 0.8,
    from = {110, 10},
    to = {-100, 10}
}
theme.net_speed_icon_bg_color = theme.net_speed_color-- theme.widget_bg
theme.net_speed_icon_fg_color = theme.bg_normal
theme.net_speed_text_color = theme.net_speed_icon_fg_color

theme.brightness_cr_color = "#00000000"
theme.brightness_cr_whole_color =
    helpers.create_gradient_color {
    color1 = "#9e4fc6",
    color2 = "#a1ffd0",
    from = {50, 10},
    to = {-60, 10}
}
theme.brightness_icon_bg_color = theme.brightness_cr_color
theme.brightness_icon_fg_color = theme.bg_normal
theme.brightness_cr_text_color = theme.brightness_icon_fg_color

theme.volume_widget_color = "#00000000"
theme.volume_widget_whole_color = helpers.create_gradient_color {
    color1 = "#e5c07b",
    color2 = "#245684",
    from = {50, 10},
    to = {-10, 10}
}
theme.volume_icon_bg_color = theme.volume_widget_color
theme.volume_icon_fg_color = theme.bg_normal
theme.volume_widget_text_color = theme.volume_icon_fg_color

theme.battery_color = "#00000000"
theme.battery_whole_color =
    helpers.create_gradient_color {
    color1 = "#3498fd",
    color2 = "#393c89",
    from = {50, 0},
    to = {0, 50}
}
theme.battery_icon_bg_color = theme.battery_color
theme.battery_icon_fg_color = theme.bg_normal
theme.battery_text_color = theme.battery_icon_fg_color
theme.battery_hover_color = "#7464f8"

theme.weather_color = "#00000000"
theme.weather_color_whole_color =
    helpers.create_gradient_color {
    color1 = "#71f1e8",
    color2 = "#b461bb",
    from = {180, 10},
    to = {-60, 10}
}
theme.weather_cold_color = helpers.create_gradient_color {
    color1 = "#71f1e8",
    color2 = "#b461bb",
    from = {180, 10},
    to = {-30, 10}
}
theme.weather_nice_color = helpers.create_gradient_color {
    color1 = "#ffc9a0",
    color2 = "#00ffed",
    from = {180, 10},
    to = {-30, 10}
}
theme.weather_hot_color = helpers.create_gradient_color {
    color1 = "#ffcda5",
    color2 = "#ae4a9e",
    from = {180, 10},
    to = {-30, 10}
}
theme.weather_widget_bg_color = theme.weather_color_whole_color
theme.weather_widget_text_color = theme.bg_normal
theme.weather_icon_bg_color = theme.weather_color
theme.weather_icon_fg_color = theme.bg_normal
theme.weather_text_color = theme.weather_icon_fg_color

theme.clock_color = helpers.create_gradient_color {
    color1 = "#7666fc",
    color2 = "#fd6cac",
    from = {250, 10},
    to = {-20, 10}
}
theme.clock_whole_color = theme.clock_color
theme.clock_icon_bg_color = "#9868e800"
theme.clock_icon_fg_color = theme.bg_normal
theme.clock_text_color = theme.clock_icon_fg_color --"#f1dc6e"

theme.prayer_times_color = helpers.create_gradient_color {
    color1 = "#ff4bde",
    color2 = "#198bee",
    from = {0, 0},
    to = {90, 90},
    stops1 = 0,
    stops2 = 0.9
}
theme.prayer_times_icon_bg_color = "#5579e8"
theme.prayer_times_icon_fg_color = theme.widget_bg
theme.prayer_times_text_color = theme.widget_bg
theme.prayer_times_inner_bg_color = theme.accent
theme.prayer_times_inner_text_color = theme.widget_bg

theme.dashboard_box_bg = theme.widget_bg
theme.dashboard_box_fg = theme.fg_normal
theme.xcolor2 = theme.fg_normal
theme.xforeground = theme.fg_normal

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- Allow desktop music widget
theme.desktop_music_widget = false
theme.desktop_music_widget_bg = "#ad42a7"
theme.desktop_music_widget_fg = "#3497fb"

--------------------------------
------------ Taglist -----------
--------------------------------
theme.taglist_fg_focus = "#da6ac1"
theme.taglist_bg_focus = theme.widget_bg

theme.taglist_fg_urgent = "#e06c75"
theme.taglist_bg_urgent = theme.widget_bg

theme.taglist_fg_occupied = "#3497fb"
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

-- لون وخصائص شريط تعديل الاضاءة والصوت في الاشعارات
theme.bar_active_color = "#da6ac1"
theme.bar_color = theme.bar_active_color .. "30"
theme.bar_handle_color = theme.bar_active_color
theme.bar_handle_border_color = theme.bar_active_color
theme.bar_height = controllers.bar_height
theme.bar_handle_width = controllers.bar_handle_width
theme.bar_handle_border_width = controllers.bar_handle_border_width
theme.bar_shape = controllers.bar_shape

-- لون وخصائص شريط عرض المعالج والرام في الاشعارات
theme.slider_color = "#da6ac1"
theme.slider_background_color = theme.slider_color .. "30"
theme.slider_forced_height = controllers.slider_forced_height
theme.slider_shape = controllers.slider_shape
theme.slider_bar_shape = controllers.slider_bar_shape

-- Volume & Brightness widget
theme.vol_bar_active_color = "#da6ac1"
theme.vol_bar_handle_color = theme.vol_bar_active_color
theme.vol_handle_border_color = theme.vol_bar_active_color
theme.vol_bar_height = controllers.vol_bar_height
theme.vol_handle_width = controllers.vol_handle_width
theme.vol_handle_border_width = controllers.vol_handle_border_width
theme.vol_bar_color = theme.vol_bar_active_color .. "30"
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
theme.wallpaper = "~/.config/awesome/themes/wallpapers/colors.jpg"

theme.music_back = "~/.config/awesome/themes/assets/no_music.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = nil
theme.icons = require("themes.icons-colors")
theme.dynamic_wallpaper_dir = "themes/wallpapers//"
theme.conky_script = "/themes/conky/conky-colors.sh"

theme.kvantum_theme = "Sweet-transparent-toolbar"
theme.konsole_profile = "--profile Aesthetic"

theme.plasma_cursors = "GoogleDot-Black"
theme.plasma_color = "Aesthetic"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
