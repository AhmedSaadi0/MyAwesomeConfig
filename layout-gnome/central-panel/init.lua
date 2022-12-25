local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local json = require("library.json")

panel_visible = false

local notif_center = require("widget.notif-center")
local music = require("widget.music") {}
local hardware_monitor = require("layout-gnome.central-panel.settings.hardware-monitor")

local central_panel = function(s)
	-- Set right panel geometry
	local panel_width = dpi(700)
	local panel_margins = dpi(15)
	local icon_font = s.font or beautiful.iconfont

	local city = s.city or beautiful.city or "Sanaa"

	local today = helpers.create_weather_detailed {}

	local weather =
		helpers.set_widget_block {
		widget = today,
		-- shape = widget_shape,
		-- bg = widget_bg,
		-- fg = widget_fg,
		top = dpi(12),
		bottom = dpi(12),
		left = dpi(24),
		right = dpi(24),
		shape = helpers.rrect(beautiful.widgets_corner_radius)
	}

	local panel =
		awful.popup {
		widget = {
			{
				{
					expand = "none",
					layout = wibox.layout.fixed.vertical,
					{
						id = "pane_id",
						visible = true,
						layout = wibox.layout.fixed.vertical,
						{
							layout = wibox.layout.flex.horizontal,
							notif_center(s),
							spacing = dpi(7),
							{
								layout = wibox.layout.fixed.vertical,
								spacing = dpi(7),
								helpers.set_widget_block {
									widget = {
										layout = wibox.layout.fixed.vertical,
										helpers.set_widget_block {
											widget = helpers.add_text("الطقس اليوم", nil, beautiful.uifont),
											bg = beautiful.header_bg,
											fg = beautiful.fg_normal,
											top = dpi(15),
											bottom = dpi(8)
										},
										weather
									},
									border_width = beautiful.slider_inner_border_width,
									border_color = beautiful.slider_inner_border_color,		
									shape = helpers.rrect(beautiful.widgets_corner_radius)
								},
								helpers.set_widget_block {
									widget = {
										layout = wibox.layout.fixed.vertical,
										helpers.set_widget_block {
											widget = helpers.add_text("الموسقى", nil, beautiful.uifont),
											bg = beautiful.header_bg,
											fg = beautiful.fg_normal,
											top = dpi(15),
											bottom = dpi(8)
										},
										music,
									},
									border_width = beautiful.slider_inner_border_width,
									border_color = beautiful.slider_inner_border_color,		
									shape = helpers.rrect(beautiful.widgets_corner_radius)
								},
								hardware_monitor
							}
						}
					}
				},
				margins = dpi(16),
				widget = wibox.container.margin
			},
			bg = beautiful.background,
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			widget = wibox.container.background
		},
		screen = s,
		-- type = "dock",
		visible = false,
		ontop = true,
		width = panel_width,
		maximum_height = beautiful.control_panal_hight,
		maximum_width = panel_width,
		height = s.geometry.height,
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		border_width = beautiful.control_border_width,
		border_color = beautiful.control_border_color,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end
	}

	awful.placement.centered(
		panel,
		{
			margins = {
				-- right = panel_margins,
				top = s.geometry.y + dpi(85)
			},
			parent = s
		}
	)

	panel.opened = false

	panel:struts {
		top = 0
	}

	local function update_weather(stdout)
		local weather_json = json.parse(stdout)

		local lang_ar = weather_json.current_condition[1].lang_ar[1].value
		local today_time = weather_json.current_condition[1].localObsDateTime
		local code = weather_json.current_condition[1].weatherCode
		local city = weather_json.nearest_area[1].areaName[1].value

		local year, month, day, hours, minutes, am_pm = today_time:match("^(%d%d%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d) ([AP]M)$")

		local w_icon = ""

		if (am_pm == "AM" and tonumber(hours) > 5) or (am_pm == "PM" and tonumber(hours) < 6) then
			w_icon = require("widget.wttr-weather.sun-icons")[code]
		else
			w_icon = require("widget.wttr-weather.moon-icons")[code]
		end

		today:get_children_by_id("temperature_id")[1]:set_text("°" .. weather_json.current_condition[1].temp_C)

		today:get_children_by_id("sky_status_id")[1]:set_text(weather_json.current_condition[1].lang_ar[1].value)
		today:get_children_by_id("weather_icon_id")[1]:set_text(w_icon)
		today:get_children_by_id("temperature_time_id")[1]:set_text(weather_json.current_condition[1].observation_time)
		today:get_children_by_id("moonrise_id")[1]:set_text(
			" " .. weather_json.weather[1].astronomy[1].moonrise .. " - " .. weather_json.weather[1].astronomy[1].moonset
		)
		today:get_children_by_id("sunrise_id")[1]:set_text(
			" " .. weather_json.weather[1].astronomy[1].sunrise .. " - " .. weather_json.weather[1].astronomy[1].sunset
		)
		today:get_children_by_id("temperature_date_id")[1]:set_text(
			" " .. os.date("%A", os.time {year = year, month = month, day = day}) .. " | " .. month .. "/" .. day
		)
		today:get_children_by_id("temperature_city_id")[1]:set_text(city)
		today:get_children_by_id("h_l_temperature_id")[1]:set_text(
			"°" .. weather_json.weather[1].maxtempC .. "/°" .. weather_json.weather[1].mintempC
		)
	end

	open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.central_panel.visible = true

		panel:emit_signal("opened")
	end

	awesome.connect_signal(
		"widget::update_weather",
		function(stdout)
			update_weather(stdout)
		end
	)

	close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.central_panel.visible = false

		panel:emit_signal("closed")
	end

	function panel:toggle()
		self.opened = not self.opened
		if self.opened then
			open_panel()
		else
			close_panel()
		end
	end

	return panel
end

return central_panel
