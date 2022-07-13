local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local icons = beautiful.icons

local quick_setting = require("layout.central-panel.settings.quick-settings")
local hardware_monitor = require("layout.central-panel.settings.hardware-monitor")

return function()
	return wibox.widget {
		layout = wibox.layout.flex.horizontal,
		spacing = dpi(7),
		quick_setting,
		hardware_monitor

		-- maximum_height = beautiful.control_panal_hight,
		-- height = beautiful.control_panal_hight,
		-- bg = beautiful.transparent,
		-- fg = beautiful.fg_normal,
		-- border_width = beautiful.border_width,
		-- border_color = beautiful.border_focus,
		-- shape = gears.shape.rounded_rect
	}
end
