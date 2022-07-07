local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local dpi = beautiful.xresources.apply_dpi
local icons = beautiful.icons
local helpers = require("helpers")

local total_prev = 0
local idle_prev = 0

local slider =
	wibox.widget {
	nil,
	{
		id = "core",
		max_value = 100,
		value = 29,
		forced_height = beautiful.slider_forced_height,
		color = beautiful.slider_color,
		background_color = beautiful.slider_background_color,
		shape = beautiful.slider_shape or gears.shape.rounded_rect,
		bar_shape = beautiful.slider_bar_shape,
		widget = wibox.widget.progressbar
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

watch(
	[[bash -c "
	cat /proc/stat | grep '^cpu '
	"]],
	10,
	function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		slider.core:set_value(math.floor(diff_usage))

		total_prev = total
		idle_prev = idle
		collectgarbage("collect")
	end
)

-- local cpu_meter =
-- 	wibox.widget {
-- 	{
-- 		{
-- 			{
-- 				image = icons.chart,
-- 				resize = true,
-- 				widget = wibox.widget.imagebox
-- 			},
-- 			point = function(geo, args)
-- 				return {
-- 					x = args.parent.width - geo.width,
-- 					y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
-- 				}
-- 			end,
-- 			top = dpi(12),
-- 			bottom = dpi(12),
-- 			widget = wibox.container.margin
-- 		},
-- 		{
-- 			slider,
-- 			top = dpi(20),
-- 			bottom = dpi(12),
-- 			right = dpi(40),
-- 			widget = wibox.container.margin
-- 		},
-- 		layout = wibox.layout.manual
-- 	},
-- 	left = dpi(24),
-- 	right = dpi(24),
-- 	forced_height = dpi(48),
-- 	widget = wibox.container.margin
-- }

local cpu_meter = helpers.create_slider_meter_widget {
	image = icons.chart,
	slider = slider,
}

return cpu_meter
