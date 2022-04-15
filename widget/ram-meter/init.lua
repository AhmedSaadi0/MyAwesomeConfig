local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local icons = require("themes.icons")

local dpi = beautiful.xresources.apply_dpi

local slider =
	wibox.widget {
	nil,
	{
		id = "ram_usage",
		max_value = 100,
		value = 29,
		forced_height = beautiful.slider_forced_height,
		color = beautiful.slider_color,
		background_color = beautiful.slider_background_color,
		shape = gears.shape.rounded_rect,
		widget = wibox.widget.progressbar
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

watch(
	'bash -c "free | grep -z Mem.*Swap.*"',
	10,
	function(_, stdout)
		local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
			stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")
		slider.ram_usage:set_value(used / total * 100)
		collectgarbage("collect")
	end
)

local ram_meter =
	wibox.widget {
	{
		{
			{
				image = icons.memory,
				resize = true,
				widget = wibox.widget.imagebox
			},
			point = function(geo, args)
				return {
					x = args.parent.width - geo.width,
					y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
				}
			end,
			top = dpi(12),
			bottom = dpi(12),
			widget = wibox.container.margin
		},
		{
			slider,
			top = dpi(20),
			bottom = dpi(12),
			right = dpi(40),
			widget = wibox.container.margin
		},
		layout = wibox.layout.manual
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

return ram_meter
