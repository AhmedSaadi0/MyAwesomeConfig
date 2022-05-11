local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")

local icons = beautiful.icons

local notifbox_core = require("widget.notif-center.build-notifbox")
local reset_notifbox_layout = notifbox_core.reset_notifbox_layout

local clear_all_imagebox =
	wibox.widget {
	{
		image = icons.clear_all,
		resize = true,
		forced_height = dpi(20),
		forced_width = dpi(20),
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.fixed.horizontal
}

local clear_all_button =
	wibox.widget {
	{
		clear_all_imagebox,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

clear_all_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				reset_notifbox_layout()
			end
		)
	)
)

local clear_all_button_wrapped =
	wibox.widget {
	nil,
	{
		clear_all_button,
		bg = beautiful.groups_bg,
		shape = gears.shape.circle,
		widget = wibox.container.background
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

return clear_all_button_wrapped
