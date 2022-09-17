local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local icons = beautiful.icons

local osd_header =
	wibox.widget {
	text = "السطوع",
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
		id = "bri_osd_slider",
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
		handle_shape = beautiful.osd_handle_shape or gears.shape.circle,
		maximum = 100,
		widget = wibox.widget.slider
	},
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

local bri_osd_slider = slider_osd.bri_osd_slider

bri_osd_slider:connect_signal(
	"property::value",
	function()
		local brightness_level = bri_osd_slider:get_value()

		awful.spawn("light -S " .. math.max(brightness_level, 5), false)

		-- Update textbox widget text
		osd_value.text = brightness_level .. "%"

		-- Update the brightness slider if values here change
		awesome.emit_signal("widget::brightness:update", brightness_level)

		if awful.screen.focused().show_bri_osd then
			awesome.emit_signal("module::brightness_osd:show", true)
		end
	end
)

bri_osd_slider:connect_signal(
	"button::press",
	function()
		awful.screen.focused().show_bri_osd = true
	end
)

bri_osd_slider:connect_signal(
	"mouse::enter",
	function()
		awful.screen.focused().show_bri_osd = true
	end
)

-- The emit will come from brightness slider
awesome.connect_signal(
	"module::brightness_osd",
	function(brightness)
		bri_osd_slider:set_value(brightness)
	end
)

local icon =
	wibox.widget {
	{
		image = icons.brightness,
		resize = true,
		widget = wibox.widget.imagebox
	},
	top = dpi(12),
	bottom = dpi(12),
	widget = wibox.container.margin
}

local brightness_slider_osd =
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
		s.show_bri_osd = false

		s.brightness_osd_overlay =
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
			-- shape = function(cr, w, h)
			-- 	gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			-- end,
			bg = beautiful.transparent,
			preferred_anchors = osd_preferred_anchors,
			preferred_positions = {"left", "right", "top", "bottom"}
		}

		s.brightness_osd_overlay:setup {
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
					brightness_slider_osd,
					layout = wibox.layout.fixed.vertical
				},
				left = dpi(15),
				right = dpi(20),
				widget = wibox.container.margin
			},
			bg = beautiful.background,
			border_color = beautiful.notification_border_focus,
			border_width = beautiful.osd_border_width,
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			widget = wibox.container.background()
		}

		-- Reset timer on mouse hover
		s.brightness_osd_overlay:connect_signal(
			"mouse::enter",
			function()
				awful.screen.focused().show_bri_osd = true
				awesome.emit_signal("module::brightness_osd:rerun")
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
		focused.brightness_osd_overlay.visible = false
		focused.show_bri_osd = false
	end
}

awesome.connect_signal(
	"module::brightness_osd:rerun",
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
	local brightness_osd = focused.brightness_osd_overlay

	-- if right_panel and left_panel then
	-- 	if right_panel.visible then
	-- 		awful.placement.bottom_right(
	-- 			brightness_osd,
	-- 			{
	-- 				margins = {
	-- 					left = osd_margin,
	-- 					right = 0,
	-- 					top = 0,
	-- 					bottom = osd_margin
	-- 				},
	-- 				honor_workarea = true
	-- 			}
	-- 		)
	-- 		return
	-- 	end
	-- end

	-- if right_panel then
	-- 	if right_panel.visible then
	-- 		awful.placement.bottom_right(
	-- 			brightness_osd,
	-- 			{
	-- 				margins = {
	-- 					left = osd_margin,
	-- 					right = 0,
	-- 					top = 0,
	-- 					bottom = osd_margin
	-- 				},
	-- 				honor_workarea = true
	-- 			}
	-- 		)
	-- 		return
	-- 	end
	-- end

	awful.placement.bottom(
		brightness_osd,
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
	"module::brightness_osd:show",
	function(bool)
		placement_placer()
		awful.screen.focused().brightness_osd_overlay.visible = bool
		if bool then
			awesome.emit_signal("module::brightness_osd:rerun")
			awesome.emit_signal("module::volume_osd:show", false)
		else
			if hide_osd.started then
				hide_osd:stop()
			end
		end
	end
)
