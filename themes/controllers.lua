
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shape = require("gears.shape")

local gears = require("gears")

local theme = {}

-- حواف حول الاضافات الذي من الشريط العلوي
local panal_stuff_border = dpi(0)

-- Sys tray
theme.systray_icon_spacing = dpi(5)
theme.systray_max_rows = dpi(1)

-- Panal
theme.panal_hight = dpi(32)
theme.panal_border_width = panal_stuff_border
-- درجة دوران حواف بعض الاشياء مثل الاشعارات واشعار الصوت والسطوع
theme.groups_radius = dpi(12)

-- Control Panal
-- theme.control_panal_hight = dpi(750) -- normal layout
theme.control_panal_hight = dpi(645) -- gnome layout
theme.control_border_width = panal_stuff_border

-- حواف حول اضافات الاشعارات
theme.slider_inner_border_width = dpi(0)

theme.bar_height = dpi(1)
theme.bar_handle_width = dpi(10)
theme.bar_handle_border_width = dpi(1)
theme.bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 30)
end

theme.slider_forced_height = dpi(1)
theme.slider_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, theme.groups_radius)
end
theme.slider_bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 0)
end

theme.vol_bar_height = dpi(1)
theme.vol_handle_width = dpi(10)
theme.vol_handle_border_width = dpi(0)

theme.osd_height = dpi(70)
theme.osd_width = dpi(220)
theme.osd_margin = dpi(90)
theme.osd_handle_shape = gears.shape.circle

-- Widget
theme.widget_height = dpi(25)

-- Generate taglist squares:
local taglist_square_size = dpi(4)

-- Decorations
theme.client_shape_rectangle = gears.shape.rectangle
theme.client_shape_rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, theme.groups_radius)
end

theme.power_button_shape = function(cr, width, height)
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
theme.osd_border_width = dpi(0)
theme.notification_spacing = dpi(30)

theme.center_notification_border_width = dpi(0)

theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

return theme