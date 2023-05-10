local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shape = require("gears.shape")

local gears = require("gears")

local controller = {}

-- حواف حول الاضافات الذي من الشريط العلوي --
local panal_stuff_border = dpi(2)

-- Bars --
local bar_height = dpi(2)
local bar_handle_width = dpi(15)
local bar_handle_border_width = dpi(0)

-- Sys tray --
controller.systray_icon_spacing = dpi(5)
controller.systray_max_rows = dpi(1)

-- Panal --
controller.panal_hight = dpi(32)
controller.panal_border_width = dpi(1)

controller.border_width = dpi(2)

-- درجة دوران حواف بعض الاشياء مثل الاشعارات واشعار الصوت والسطوع --
controller.groups_radius = dpi(10)
controller.windows_radius = dpi(6)

-- Control Panal --
-- theme.control_panal_hight = dpi(750) -- normal layout
controller.control_panal_hight = dpi(645) -- gnome layout
controller.control_border_width = panal_stuff_border

-- حواف حول اضافات الاشعارات --
controller.slider_inner_border_width = dpi(0)

controller.bar_height = bar_height
controller.bar_handle_width = bar_handle_width
controller.bar_handle_border_width = bar_handle_border_width
controller.bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 30)
end

controller.slider_forced_height = bar_height
controller.slider_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, controller.groups_radius)
end
controller.slider_bar_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, 0)
end

controller.vol_bar_height = bar_height
controller.vol_handle_width = bar_handle_width
controller.vol_handle_border_width = bar_handle_border_width

controller.osd_height = dpi(70)
controller.osd_width = dpi(280)
controller.osd_margin = dpi(90)
controller.osd_handle_shape = gears.shape.circle

-- Widget --
controller.widget_height = dpi(25)

-- Generate taglist squares: --
local taglist_square_size = dpi(4)

-- Decorations --
controller.client_shape_rectangle = gears.shape.rectangle
controller.client_shape_rounded = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, controller.windows_radius)
end

controller.power_button_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, controller.groups_radius)
end

-- Variables set for theming notifications: --
controller.notification_title_margin = dpi(6)
controller.notification_body_left_margin = dpi(7)
controller.notification_body_right_margin = dpi(7)
controller.notification_body_top_margin = dpi(8)
controller.notification_body_bottom_margin = dpi(6)
controller.notification_body_margins = dpi(6)
-- theme.notification_margins = dpi(60)

controller.notification_icon_margin = dpi(2)
controller.osd_border_width = panal_stuff_border
controller.notification_spacing = dpi(30)

controller.center_notification_border_width = dpi(0)

controller.menu_height = dpi(15)
controller.menu_width = dpi(100)

return controller
