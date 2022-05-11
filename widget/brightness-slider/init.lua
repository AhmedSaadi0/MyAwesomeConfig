local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = beautiful.icons
local clickable_container = require("widget.clickable-container")

local icon =
	wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = "none",
	nil,
	{
		image = icons.brightness,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local action_level =
	wibox.widget {
	{
		icon,
		widget = clickable_container
	},
	bg = beautiful.transparent,
	shape = gears.shape.circle,
	widget = wibox.container.background
}

local slider =
	wibox.widget {
	nil,
	{
		id = "brightness_slider",
		bar_shape = beautiful.bar_shape,
		bar_height = beautiful.bar_height,
		bar_color = beautiful.bar_color,
		bar_active_color = beautiful.bar_active_color,
		handle_color = beautiful.bar_handle_color,
		handle_shape = gears.shape.circle,
		handle_border_color = beautiful.handle_border_color,
		handle_width = beautiful.bar_handle_width,
		handle_border_width = beautiful.handle_border_width,
		maximum = 100,
		widget = wibox.widget.slider
	},
	nil,
	point = function(geo, args)
		return {
			x = (args.parent.width / 2 + (geo.width / 2)) - geo.width,
			y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
		}
	end,
	expand = "none",
	-- forced_height = dpi(24),
	layout = wibox.layout.align.vertical
}

local brightness_slider = slider.brightness_slider

brightness_slider:connect_signal(
	"property::value",
	function()
		local brightness_level = brightness_slider:get_value()

		spawn("light -S " .. math.max(brightness_level, 5), false)

		-- Update brightness osd
		awesome.emit_signal("module::brightness_osd", brightness_level)
	end
)

brightness_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if brightness_slider:get_value() > 100 then
					brightness_slider:set_value(100)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if brightness_slider:get_value() < 0 then
					brightness_slider:set_value(0)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() - 5)
			end
		)
	)
)

local update_slider = function()
	awful.spawn.easy_async_with_shell(
		"light -G",
		function(stdout)
			local brightness = string.match(stdout, "(%d+)")
			brightness_slider:set_value(tonumber(brightness))
		end
	)
end

-- Update on startup
update_slider()

local action_jump = function()
	local sli_value = brightness_slider:get_value()
	local new_value = 0

	if sli_value >= 0 and sli_value < 50 then
		new_value = 50
	elseif sli_value >= 50 and sli_value < 100 then
		new_value = 100
	else
		new_value = 0
	end
	brightness_slider:set_value(new_value)
end

action_level:buttons(
	awful.util.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				action_jump()
			end
		)
	)
)

-- The emit will come from the global keybind
awesome.connect_signal(
	"widget::brightness",
	function()
		update_slider()
	end
)

-- The emit will come from the OSD
awesome.connect_signal(
	"widget::brightness:update",
	function(value)
		brightness_slider:set_value(tonumber(value))
	end
)

local brightness_setting =
	wibox.widget {
	{
		{
			point = function(geo, args)
				return {
					x = args.parent.width - geo.width,
					y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
				}
			end,
			action_level,
			top = dpi(12),
			bottom = dpi(12),
			widget = wibox.container.margin
		},
		{
			slider,
			top = dpi(12),
			bottom = dpi(12),
			right = dpi(60),
			widget = wibox.container.margin
		},
		layout = wibox.layout.manual
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(60),
	widget = wibox.container.margin
}

return brightness_setting
