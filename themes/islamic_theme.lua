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
theme.hotkeys_font = theme.uifont

-- theme.widget_font = "Font Awesome 5 Free Solid 11"
theme.widget_font = theme.uifont
theme.iconfont = "Font Awesome 5 Free Solid 11"

-------------------------------
------------ Colors -----------
-------------------------------
theme.accent = "#f1dc6e"

theme.bg_normal = "#012549"
theme.widget_bg = "#011426"
theme.bg_focus = "#16161e"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"

theme.fg_normal = "#92a0bd"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_normal = "#e06c75"
theme.border_focus = "#f1dc6e"
theme.border_marked = "#7ec7a2"

-- colors
theme.power_button_color = "#fedb41"
theme.taglist_color = "#a4dfff"

theme.keyboard_layout_color = "#aa55ff"
theme.keyboard_icon_bg_color = "#8744cb" -- "#aaaaff"
theme.keyboard_icon_fg_color = theme.widget_bg -- "#aaaaff"
theme.keyboard_text_color = theme.widget_bg -- "#aaaaff"

theme.cpu_color = "#e2ad57"
theme.cpu_icon_color = "#e2ad57" --"#ff79c6"

theme.cpu_temp_color = "#e2ad57"
theme.cpu_temp_icon_bg_color = "#c8994d" -- "#00efd1"
theme.cpu_temp_icon_fg_color = theme.widget_bg
theme.cpu_temp_text_color = theme.cpu_temp_icon_fg_color

theme.net_speed_color = "#ff5558"
theme.net_speed_icon_bg_color = "#b83d3f" -- "#00efd1"
theme.net_speed_icon_fg_color = theme.widget_bg
theme.net_speed_text_color = theme.net_speed_icon_fg_color

theme.brightness_cr_color = "#7aa2f7"
theme.brightness_icon_bg_color = "#668ee3" -- "#ffaaff"
theme.brightness_icon_fg_color = theme.widget_bg
theme.brightness_cr_text_color = theme.brightness_icon_fg_color

theme.volume_widget_color = "#e5c07b"
theme.volume_icon_bg_color = "#bfa067" -- "#ffaaff"
theme.volume_icon_fg_color = theme.widget_bg
theme.volume_widget_text_color = theme.volume_icon_fg_color

theme.battery_color = "#0781f4"
theme.battery_icon_bg_color = "#0569c7" -- "#ffaf5f"
theme.battery_icon_fg_color = theme.widget_bg
theme.battery_text_color = theme.battery_icon_fg_color
theme.battery_hover_color = "#92a0bd" -- "#ffaf5f"

theme.weather_color = "#033768"
theme.weather_icon_bg_color = "#044583"
theme.weather_icon_fg_color = "#92a0bd"
theme.weather_text_color = theme.weather_icon_fg_color

theme.clock_color = "#f1dc6e"
theme.clock_icon_bg_color = "#b1a151"
theme.clock_icon_fg_color = theme.widget_bg
theme.clock_text_color = theme.widget_bg

theme.dashboard_box_bg = theme.widget_bg
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

theme.taglist_fg_occupied = "#60c29f"
theme.taglist_bg_occupied = theme.widget_bg

theme.taglist_fg_empty = "#545862"
theme.taglist_bg_empty = theme.widget_bg

-- theme.taglist_shape = shape.rectangle -- rounded_bar
theme.taglist_font = theme.iconfont

-- Sys tray --
theme.bg_systray = theme.bg_normal
theme.systray_icon_spacing = dpi(5)
theme.systray_max_rows = dpi(1)

-- Panal --
theme.panal_hight = dpi(32)
theme.panal_border_width = dpi(0)
-- درجة دوران حواف بعض الاشياء مثل الاشعارات واشعار الصوت والسطوع
theme.groups_radius = dpi(15)

-- Control Panal and notification panal
theme.control_panal_hight = dpi(750)
theme.control_border_width = dpi(1)
theme.control_border_color = theme.border_focus

-- حواف حول اضافات الاشعارات
theme.slider_inner_border_color = "#458588"
theme.slider_inner_border_width = dpi(0)

-- خلفية ولون اضافات الاشعارات
theme.groups_title_bg = theme.widget_bg
theme.groups_bg = theme.widget_bg
theme.background = theme.bg_normal

theme.transparent = "#00000000"

theme.media_button_color = theme.accent

-- widgets --
-- لعمل حواف مستديرة في الاضافات على الشريط العلوي
theme.widgets_corner_radius = theme.groups_radius

-- لون وخصائص شريط تعديل الاضاءة والصوت في الاشعارات
theme.bar_active_color = theme.accent
theme.bar_color = theme.bar_active_color .. "30"
theme.bar_handle_color = theme.bar_active_color
theme.bar_handle_border_color = theme.bar_active_color
theme.bar_height = dpi(10)
theme.bar_handle_width = dpi(10)
theme.bar_handle_border_width = dpi(0)
theme.bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.groups_radius)
end

-- لون وخصائص شريط عرض المعالج والرام في الاشعارات
theme.slider_color = theme.accent
theme.slider_background_color = theme.slider_color .. "30"
theme.slider_forced_height = dpi(10)
theme.slider_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.groups_radius)
end
theme.slider_bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 0)
end

-- Volume & Brightness widget
theme.vol_bar_active_color = theme.accent
theme.vol_bar_handle_color = theme.vol_bar_active_color
theme.vol_handle_border_color = theme.vol_bar_active_color
theme.vol_bar_height = dpi(10)
theme.vol_handle_width = dpi(10)
theme.vol_handle_border_width = dpi(0)
theme.vol_bar_color = theme.vol_bar_active_color .. "30"
theme.vol_bar_shape = theme.bar_shape

theme.osd_height = dpi(70)
theme.osd_width = dpi(220)
theme.osd_margin = dpi(90)
theme.osd_handle_shape = gears.shape.circle

-- Widget
theme.widget_height = dpi(25)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Decorations
theme.client_shape_rectangle = gears.shape.rectangle
theme.client_shape_rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, theme.groups_radius)
end

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
theme.notification_border_width = dpi(1)
theme.notification_spacing = dpi(30)

theme.center_notification_border_focus = theme.border_focus
theme.center_notification_border_width = dpi(0)

theme.lock_bg = theme.bg_normal .. "77"

theme.header_bg = "#011426"
theme.inner_bg = "#011426"

theme.notification_center_header_bg = "#011426"
theme.notification_center_inner_bg = "#011426"

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
theme.wallpaper = "~/.config/awesome/themes/wallpapers/islamic-wallpaper.jpg"

theme.icon_theme = nil
theme.icons = require("themes.icons-islamic")
theme.dynamic_wallpaper_dir = "themes/wallpapers//"
theme.conky_script = "/configuration/conky-dark.sh"
-- theme.kvantum_theme = "Islamic"
theme.kvantum_theme = "Glorious-dark"
theme.konsole_profile = "--profile islamic"

theme.light_theme = "light_theme"
theme.dark_theme = "islamic_theme"

theme.plasma_cursors = "ArcStarry-cursors"
theme.plasma_color = "Tellgo.colors"

return theme
