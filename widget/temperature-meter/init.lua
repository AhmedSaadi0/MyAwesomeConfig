local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi
local icons = beautiful.icons
local helpers = require("helpers")

local slider =
	wibox.widget {
	nil,
	{
		id = "core",
		max_value = 100,
		value = 0,
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

local max_temp = 80

watch(
	"sensors",
	5,
	function(_, out)
		for line in out:gmatch("[^\r\n]+") do
			if line:match("temp1") then
				local degree = helpers.trim(string.match(string.gsub(line, "temp1", ""), "%d+"))
				slider.core:set_value(math.floor(degree))
			end
		end
	end
)

local temperature_meter =
	helpers.create_slider_meter_widget {
	image = icons.thermometer,
	slider = slider
}

return temperature_meter
