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

local controllers = require("themes.controllers")

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
theme.hotkeys_font = theme.uifont

-------------------------------
------------ Colors -----------
-------------------------------
theme.accent = "#5d484c"


theme.bg_normal = "#ffdad9"
theme.widget_bg = "#e9c7c6"
theme.bg_focus = theme.widget_bg
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#4c566a"
theme.fg_focus = "#fef6e1"
theme.fg_urgent = "#fef6e1"
theme.fg_minimize = "#fef6e1"

theme.useless_gap = dpi(5)
theme.border_width = controllers.border_width
theme.border_normal = "#00000000"
theme.border_focus = "#5d484c"
theme.border_marked = "#00000000"

-- bar widgets colors
theme.taglist_color = "#4c566a" -- "#dddddd"
theme.power_button_color = "#4c566a" -- "#fedb41"

theme.keyboard_layout_color = "#dfdce7" 
theme.keyboard_icon_bg_color = "#dfdce7" 
theme.keyboard_icon_fg_color = theme.fg_normal 
theme.keyboard_text_color = theme.fg_normal 

theme.cpu_color = theme.fg_normal --"#ff79c6"
theme.cpu_icon_color = theme.fg_normal --"#ff79c6"

theme.cpu_temp_color = "#92b9b8"
theme.cpu_temp_icon_bg_color = "#92b9b8"
theme.cpu_temp_icon_fg_color = theme.fg_normal
theme.cpu_temp_icon_high_bg_color = theme.fg_normal
theme.cpu_temp_text_color = theme.fg_normal

theme.net_speed_color = "#75afb1"
theme.net_speed_icon_bg_color = "#75afb1"
theme.net_speed_icon_fg_color = theme.fg_normal
theme.net_speed_text_color = theme.fg_normal

theme.brightness_cr_color = "#eca3ac"
theme.brightness_icon_bg_color = "#eca3ac"
theme.brightness_icon_fg_color = theme.fg_normal
theme.brightness_cr_text_color = theme.brightness_icon_fg_color

theme.volume_widget_color = theme.widget_bg
theme.volume_icon_bg_color = theme.widget_bg
theme.volume_icon_fg_color = theme.fg_normal
theme.volume_widget_text_color = theme.fg_normal

theme.battery_color = "#595380"
theme.battery_icon_bg_color = "#595380"
theme.battery_icon_fg_color = "#fdf5e0"
theme.battery_text_color = theme.battery_icon_fg_color
theme.battery_hover_color = "#00000000"

theme.weather_color = "#fec2a6"
theme.weather_icon_bg_color = "#fec2a6"
theme.weather_icon_fg_color = theme.fg_normal
theme.weather_text_color = theme.weather_icon_fg_color

theme.clock_color = theme.accent
theme.clock_whole_color = theme.clock_color
theme.clock_icon_bg_color = theme.accent
theme.clock_icon_fg_color = theme.fg_focus
theme.clock_text_color = theme.fg_focus

theme.dashboard_box_bg = theme.widget_bg
theme.dashboard_box_fg = theme.fg_normal
theme.xcolor2 = theme.fg_normal
theme.xforeground = theme.fg_normal

theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal
theme.tooltip_font = theme.font

-- Desktop music widget
theme.light_my3_theme_widgets = true

--------------------------------
------------ Taglist -----------
--------------------------------
theme.taglist_fg_focus = "#5d484c"
theme.taglist_bg_focus = theme.widget_bg

theme.taglist_fg_urgent = "#d3929a"
theme.taglist_bg_urgent = theme.widget_bg

theme.taglist_fg_occupied = "#598587"
theme.taglist_bg_occupied = theme.widget_bg

theme.taglist_fg_empty = "#bfa3a3"
theme.taglist_bg_empty = theme.widget_bg

-- theme.taglist_shape = shape.rectangle -- rounded_bar
theme.taglist_font = theme.iconfont

----------------------------------
------------ Sys tray ------------
----------------------------------
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = controllers.systray_icon_spacing
theme.systray_max_rows = controllers.systray_max_rows

-------------------------------
------------ Panal ------------
-------------------------------
theme.panal_hight = controllers.panal_hight
theme.panal_border_width = controllers.panal_border_width
-- درجة دوران حواف بعض الاشياء مثل الاشعارات واشعار الصوت والسطوع
theme.groups_radius = dpi(30)

----------------------------------------------------------------
-------------- Control Panal and notification panal ------------
----------------------------------------------------------------
theme.control_panal_hight = controllers.control_panal_hight
theme.control_border_width = controllers.control_border_width
theme.control_border_color = theme.border_focus

-- Control panal widgets - الاعدادت السريعة واستخدام الاجهزة وغيرها
theme.slider_inner_border_color = theme.border_focus
theme.slider_inner_border_width = controllers.slider_inner_border_width

theme.groups_title_bg = theme.widget_bg
theme.groups_bg = theme.widget_bg
theme.background = theme.bg_normal

theme.transparent = "#00000000"

theme.media_button_color = theme.fg_normal

-- widgets --
-- لعمل حواف مستديرة في الاضافات على الشريط العلوي
theme.widgets_corner_radius = theme.groups_radius

-- لون وخصائص شريط تعديل الاضاءة والصوت في الاشعارات
theme.bar_active_color = theme.accent
theme.bar_color = theme.bar_active_color .. "30"
theme.bar_handle_color = theme.bar_active_color
theme.bar_handle_border_color = theme.bar_active_color
theme.bar_height = controllers.bar_height
theme.bar_handle_width = controllers.bar_handle_width
theme.bar_handle_border_width = controllers.bar_handle_border_width
theme.bar_shape = controllers.bar_shape

-- لون وخصائص شريط عرض المعالج والرام في الاشعارات
theme.slider_color = theme.accent
theme.slider_background_color = theme.slider_color .. "30"
theme.slider_forced_height = controllers.slider_forced_height
theme.slider_shape = controllers.slider_shape
theme.slider_bar_shape = controllers.slider_bar_shape

-- Volume & Brightness widget
theme.vol_bar_active_color = theme.accent
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
theme.osd_preferred_anchors = "left"

-- Widget
theme.widget_height = controllers.widget_height

-- Generate taglist squares:
local taglist_square_size = controllers.taglist_square_size

-- Decorations
theme.client_shape_rectangle = controllers.client_shape_rectangle
theme.client_shape_rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, theme.groups_radius)
end

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
theme.power_button_bg = theme.widget_bg .. "77"

theme.header_bg = theme.widget_bg
theme.inner_bg = theme.widget_bg

theme.notification_center_header_bg = theme.widget_bg
theme.notification_center_inner_bg = theme.widget_bg

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
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

-- theme.wallpaper = "~/.config/awesome/themes/wallpapers/mountains.jpg"
theme.wallpaper = "~/.config/awesome/themes/wallpapers/pastel.jpg"

theme.music_back = "~/.config/awesome/themes/assets/no_music.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
-- panal icons
theme.icons = require("themes.icons-material-you")

theme.dynamic_wallpaper_dir = "themes/light-wallpapers//"
theme.conky_script = "/themes/conky/m3.sh"

theme.kvantum_theme = "a-m-you"
theme.konsole_profile = "--profile material-you"
-- theme.qt_icon_theme = "Oreo-black-circle"
theme.qt_icon_theme = "kora-grey-light-panel"
theme.qt_style_theme = "Lightly"

theme.gtk_theme = "WhiteSur-Light-red"

theme.plasma_cursors = "GoogleDot-Black"
-- theme.plasma_color = "NovaAmare.colors"
theme.plasma_color = "MyMaterialYou.colors"

return theme
