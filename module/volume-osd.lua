local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local icons = beautiful.icons

local osd_header =
	wibox.widget {
	text = "مستوى الصوت",
	font = beautiful.uifont,
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local osd_value =
	wibox.widget {
	text = "0%",
	font = beautiful.uifont,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

local slider_osd =
	wibox.widget {
	nil,
	{
		id = "vol_osd_slider",
		-- bar_shape = gears.shape.rounded_rect,
		bar_shape = beautiful.vol_bar_shape,
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

local vol_osd_slider = slider_osd.vol_osd_slider

vol_osd_slider:connect_signal(
	"property::value",
	function()
		local volume_level = vol_osd_slider:get_value()
		awful.spawn("amixer -D pulse sset Master " .. volume_level .. "%", false)

		-- Update textbox widget text
		osd_value.text = volume_level .. "%"

		-- Update the volume slider if values here change
		awesome.emit_signal("widget::volume:update", volume_level)

		if awful.screen.focused().show_vol_osd then
			awesome.emit_signal("module::volume_osd:show", true)
		end
	end
)

vol_osd_slider:connect_signal(
	"button::press",
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

vol_osd_slider:connect_signal(
	"mouse::enter",
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

-- The emit will come from the volume-slider
awesome.connect_signal(
	"module::volume_osd",
	function(volume)
		vol_osd_slider:set_value(volume)
	end
)

local icon =
	wibox.widget {
	{
		image = icons.volume,
		resize = true,
		widget = wibox.widget.imagebox
	},
	top = dpi(12),
	bottom = dpi(12),
	widget = wibox.container.margin
}

local volume_slider_osd =
	wibox.widget {
	icon,
	slider_osd,
	spacing = dpi(10),
	layout = wibox.layout.fixed.horizontal
}

local osd_height = beautiful.osd_height or dpi(130)
local osd_width = beautiful.osd_width or dpi(270)
local osd_margin = beautiful.osd_margin or dpi(90)
local osd_preferred_anchors = beautiful.osd_preferred_anchors or "middle"

screen.connect_signal(
	"request::desktop_decoration",
	function(s)
		local s = s or {}
		s.show_vol_osd = false

		-- Create the box
		s.volume_osd_overlay =
			awful.popup {
			widget = {},
			ontop = true,
			visible = false,
			type = "notification",
			screen = s,
			height = osd_height,
			width = osd_width,
			maximum_height = osd_height,
			maximum_width = osd_width,
			offset = dpi(5),
			-- shape = gears.shape.rectangle,
			handle_shape = beautiful.osd_handle_shape or gears.shape.circle,
			bg = beautiful.transparent,
			preferred_anchors = osd_preferred_anchors,
			preferred_positions = {"left", "right", "top", "bottom"}
		}

		s.volume_osd_overlay:setup {
			{
				{
					-- {
					-- 	layout = wibox.layout.align.horizontal,
					-- 	expand = "none",
					-- 	forced_height = dpi(48),
					-- 	osd_value,
					-- 	nil,
					-- 	osd_header
					-- },
					volume_slider_osd,
					layout = wibox.layout.fixed.vertical
				},
				left = dpi(15),
				right = dpi(20),
				widget = wibox.container.margin
			},
			bg = beautiful.background,
			-- shape = gears.shape.rounded_rect,
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			border_color = beautiful.notification_border_focus,
			border_width = beautiful.notification_border_width,
			widget = wibox.container.background()
		}

		-- Reset timer on mouse hover
		s.volume_osd_overlay:connect_signal(
			"mouse::enter",
			function()
				awful.screen.focused().show_vol_osd = true
				awesome.emit_signal("module::volume_osd:rerun")
			end
		)
	end
)

local hide_osd =
	gears.timer {
	timeout = 2,
	autostart = true,
	callback = function()
		local focused = awful.screen.focused()
		focused.volume_osd_overlay.visible = false
		focused.show_vol_osd = false
	end
}

awesome.connect_signal(
	"module::volume_osd:rerun",
	function()
		if hide_osd.started then
			hide_osd:again()
		else
			hide_osd:start()
		end
	end
)

local placement_placer = function()
	local focused = awful.screen.focused()

	local right_panel = focused.right_panel
	local left_panel = focused.left_panel
	local volume_osd = focused.volume_osd_overlay

	awful.placement.bottom(
		volume_osd,
		{
			margins = {
				left = 0,
				right = 0,
				top = 0,
				bottom = osd_margin
			},
			honor_workarea = true
		}
	)
end

awesome.connect_signal(
	"module::volume_osd:show",
	function(bool)
		placement_placer()
		awful.screen.focused().volume_osd_overlay.visible = bool
		if bool then
			awesome.emit_signal("module::volume_osd:rerun")
			awesome.emit_signal("module::brightness_osd:show", false)
		else
			if hide_osd.started then
				hide_osd:stop()
			end
		end
	end
)
