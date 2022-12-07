local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local clickable_container = require("widget.blue-light.clickable-container")
local icons = beautiful.icons
local blue_light_state = nil
local helpers = require("helpers")

local action_name =
	wibox.widget {
	text = "تقليل الضوء الازرق",
	font = beautiful.uifont,
	align = "right",
	widget = wibox.widget.textbox
}

local action_name =
	helpers.add_text_icon_widget {
	text = "تقليل الضوء الازرق",
	icon = "",
	ltr = true,
	icon_font = beautiful.iconfont,
	forced_width = dpi(135),
	text_font = beautiful.uifont
}

local button_widget =
	wibox.widget {
	{
		id = "icon",
		image = icons.toggled_off,
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button =
	wibox.widget {
	{
		button_widget,
		top = dpi(7),
		bottom = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

local update_imagebox = function()
	local button_icon = button_widget.icon
	if blue_light_state then
		button_icon:set_image(icons.toggled_on)
	else
		button_icon:set_image(icons.toggled_off)
	end
end

local slider_osd =
	wibox.widget {
	nil,
	{
		id = "b_ight_osd_slider",
		-- bar_shape = gears.shape.rounded_rect,
		bar_shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 30)
		end,
		bar_height = beautiful.vol_bar_height,
		bar_color = beautiful.vol_bar_color,
		bar_active_color = beautiful.vol_bar_active_color,
		handle_color = beautiful.vol_bar_handle_color,
		handle_border_color = beautiful.vol_handle_border_color,
		handle_width = beautiful.vol_handle_width,
		handle_border_width = beautiful.vol_handle_border_width,
		handle_shape = gears.shape.circle,
		maximum = 100,
		widget = wibox.widget.slider
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

local b_ight_osd_slider = slider_osd.b_ight_osd_slider

b_ight_osd_slider:connect_signal(
	"property::value",
	function()
		local bluelight_level = b_ight_osd_slider:get_value()

		awful.spawn("light -S " .. math.max(bluelight_level, 5), false)

		-- Update textbox widget text
		osd_value.text = bluelight_level .. "%"

		-- Update the bluelight slider if values here change
		awesome.emit_signal("widget::bluelight:update", bluelight_level)

		if awful.screen.focused().show_b_ight_osd then
			awesome.emit_signal("module::bluelight_osd:show", true)
		end
	end
)

b_ight_osd_slider:connect_signal(
	"button::press",
	function()
		awful.screen.focused().show_b_ight_osd = true
	end
)

b_ight_osd_slider:connect_signal(
	"mouse::enter",
	function()
		awful.screen.focused().show_b_ight_osd = true
	end
)

-- The emit will come from bluelight slider
awesome.connect_signal(
	"module::bluelight_osd",
	function(bluelight)
		b_ight_osd_slider:set_value(bluelight)
	end
)

local kill_state = function()
	awful.spawn.easy_async_with_shell(
		[[
		redshift -x
		kill -9 $(pgrep redshift)
		]],
		function(stdout)
			stdout = tonumber(stdout)
			if stdout then
				blue_light_state = false
				update_imagebox()
			end
		end
	)
end

kill_state()

local toggle_action = function()
	awful.spawn.easy_async_with_shell(
		[[
		if [ ! -z $(pgrep redshift) ];
		then
			redshift -x && pkill redshift && killall redshift
			echo 'OFF'
		else
			redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
			echo 'ON'
		fi
		]],
		function(stdout)
			if stdout:match("ON") then
				blue_light_state = true
			else
				blue_light_state = false
			end
			update_imagebox()
		end
	)
end

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_action()
			end
		)
	)
)

local action_widget =
	wibox.widget {
	{
		{
			widget_button,
			layout = wibox.layout.fixed.horizontal
		},
		nil,
		action_name,
		layout = wibox.layout.align.horizontal
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

awesome.connect_signal(
	"widget::blue_light:toggle",
	function()
		toggle_action()
	end
)

return action_widget
