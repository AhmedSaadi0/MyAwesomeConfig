local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local hardware_header =
	wibox.widget {
	text = "استخدام الأجهزة",
	font = beautiful.uifont,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

return wibox.widget {
	layout = wibox.layout.fixed.vertical,
	-- {
	-- 	{
	-- 		hardware_header,
	-- 		left = dpi(24),
	-- 		right = dpi(24),
	-- 		widget = wibox.container.margin
	-- 	},
	-- 	bg = beautiful.groups_title_bg,
	-- 	shape = function(cr, width, height)
	-- 		gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.groups_radius)
	-- 	end,
	-- 	forced_height = dpi(35),
	-- 	widget = wibox.container.background
	-- },
	{
		{
			{
				{
					hardware_header,
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
			require("widget.cpu-meter"),
			require("widget.ram-meter"),
			require("widget.temperature-meter"),
			require("widget.harddrive-meter")
		},
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		-- shape = function(cr, width, height)
		-- 	gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.groups_radius)
		-- end,
		border_width = beautiful.slider_inner_border_width,
		border_color = beautiful.slider_inner_border_color,
		widget = wibox.container.background
	}
}
