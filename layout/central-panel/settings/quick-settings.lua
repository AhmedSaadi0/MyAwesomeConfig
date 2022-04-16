local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local bar_color = beautiful.groups_bg
local dpi = beautiful.xresources.apply_dpi

local brightness_slider = require("widget.brightness-slider")
local volume_slider = require("widget.volume-slider")
local airplane_mode = require("widget.airplane-mode")
local bluetooth_toggle = require("widget.bluetooth-toggle")
local blue_light = require("widget.blue-light")

local blur_slider = require("widget.blur-slider")
local blur_toggle = require("widget.blur-toggle")

local quick_header =
	wibox.widget {
	text = "اعدادات سريعة",
	font = beautiful.uifont,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(7),
	{
		layout = wibox.layout.fixed.vertical,
		-- {
		-- 	{
		-- 		quick_header,
		-- 		left = dpi(24),
		-- 		right = dpi(24),
		-- 		widget = wibox.container.margin
		-- 	},
		-- 	forced_height = dpi(35),
		-- 	bg = beautiful.groups_title_bg,
		-- 	shape = function(cr, width, height)
		-- 		gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius)
		-- 	end,
		-- 	border_width = beautiful.slider_inner_border_width,
		-- 	border_color = beautiful.slider_inner_border_color,

		-- 	widget = wibox.container.background
		-- },
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(7),
			{
				{
					{
						{
							quick_header,
							left = dpi(24),
							top = dpi(15),
							bottom = dpi(15),
							right = dpi(24),
							widget = wibox.container.margin
						},
						bg = beautiful.header_bg,
						widget = wibox.container.background
					},
					layout = wibox.layout.fixed.vertical,
					brightness_slider,
					volume_slider,
					airplane_mode,
					bluetooth_toggle,
					blue_light
				},
				bg = beautiful.groups_bg,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
				end,
				border_width = beautiful.slider_inner_border_width,
				border_color = beautiful.slider_inner_border_color,
				widget = wibox.container.background
			},
			{
				{
					layout = wibox.layout.fixed.vertical,
					blur_slider,
					blur_toggle
				},
				bg = beautiful.groups_bg,
				shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
				end,
				border_width = beautiful.slider_inner_border_width,
				border_color = beautiful.slider_inner_border_color,
				widget = wibox.container.background
			}
		}
	}
}
