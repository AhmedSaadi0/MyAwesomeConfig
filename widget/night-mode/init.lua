local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local clickable_container = require("widget.blur-toggle.clickable-container")
local dpi = require("beautiful").xresources.apply_dpi
local filesystem = gears.filesystem
local config_dir = filesystem.get_configuration_dir()
local beautiful = require("beautiful")
local icons = beautiful.icons
local helpers = require("helpers")

-- local action_name =
-- 	wibox.widget {
-- 	text = "الوضع الليلي",
-- 	font = beautiful.uifont,
-- 	align = "right",
-- 	widget = wibox.widget.textbox
-- }

local action_name =
	helpers.add_text_icon_widget {
	text = "الوضع الليلي",
	icon = "",
	forced_width = dpi(107),
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

local action_status

local update_imagebox = function()
	if action_status then
		button_widget.icon:set_image(icons.toggled_on)
	else
		button_widget.icon:set_image(icons.toggled_off)
	end
end

local check_mode_status = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "grep -F 'light_theme' ]] .. config_dir .. [[rc.lua | tr -d '[\"\;\=\ ]'"]],
		function(stdout, stderr)
			if string.find(stdout, "light_theme") then
				action_status = false
			else
				action_status = true
			end

			update_imagebox()
		end
	)
end

check_mode_status()

local toggle_night_mode = function(togglemode)
	local toggle_n_m_script =
		[[bash -c "
			case ]] ..
		togglemode ..
			[[ in
				'enable')
				sed -i -e 's/]] ..
				beautiful.light_theme ..
					[[/]] ..
						beautiful.dark_theme ..
							[[/g' \"]] ..
								config_dir ..
									[[rc.lua\";;'disable')
				sed -i -e 's/]] ..
										beautiful.dark_theme ..
											[[/]] .. beautiful.light_theme .. [[/g' \"]] .. config_dir .. [[rc.lua\";;
			esac
	"]]

	-- Run the script
	awful.spawn.with_shell(toggle_n_m_script)
	awful.spawn.with_shell("echo 'awesome.restart()' | awesome-client")
end

local toggle_mode_fx = function()
	local state = nil
	if action_status then
		action_status = false
		state = "disable"
	else
		action_status = true
		state = "enable"
	end
	toggle_night_mode(state)
	update_imagebox()
end

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_mode_fx()
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
	"widget::night:toggle",
	function()
		toggle_mode_fx()
	end
)

return action_widget
