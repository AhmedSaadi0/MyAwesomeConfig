local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi
local icons = require("themes.icons")

local slider =
	wibox.widget {
	nil,
	{
		id = "temp_status",
		max_value = 200,
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

local max_temp = 80

awful.spawn.easy_async_with_shell(
	[[
	temp_path=null
	for i in /sys/class/hwmon/hwmon*/temp*_input;
	do
		temp_path="$(echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null ||
			echo $(basename ${i%_*})) $(readlink -f $i)");"

		label="$(echo $temp_path | awk '{print $2}')"

		if [ "$label" = "Package" ];
		then
			echo ${temp_path} | awk '{print $5}' | tr -d ';\n'
			exit;
		fi
	done
	]],
	function(stdout)
		local temp_path = stdout:gsub("%\n", "")
		if temp_path == "" or not temp_path then
			temp_path = "/sys/class/thermal/thermal_zone0/temp"
		end

		watch(
			[[
			sh -c "cat ]] .. temp_path .. [["
			]],
			10,
			function(_, stdout)
				local temp = stdout:match("(%d+)")
				slider.temp_status:set_value((temp / 1000) / max_temp * 100)
				collectgarbage("collect")
			end
		)
	end
)

local temperature_meter =
	wibox.widget {
	{
		{
			{
				image = icons.thermometer,
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

return temperature_meter
