local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local watch = require("awful").widget.watch
local awful = require("awful")

local function worker(args)
	local forced_width = args.forced_width

	local separate_line = args.separate_line or dpi(1)
	local line_margin_left = args.line_margin_left
	local line_margin_right = args.line_margin_right
	local line_forced_height = args.line_forced_height

	local clock_forced_width = args.clock_forced_width or dpi(280)

	local clock_bg = args.clock_bg or beautiful.transparent
	local clock_shape = args.clock_shape
	local clock_right = args.clock_right
	local clock_left = args.clock_left
	local clock_top = args.clock_top
	local clock_bottom = args.clock_bottom

	local day_text_font = args.day_text_font or "JF Flat 25"
	local day_text_color = args.day_text_color or beautiful.accent

	local time_now_text_font = args.day_text_font or "JF Flat 20"
	local time_now_text_color = args.time_now_text_color or beautiful.accent
	local tim_now_top  = args.tim_now_top  or dpi(15)

	local month_name_text_font = args.month_name_text_font or "JF Flat 25"
	local month_name_text_color = args.month_name_text_color or beautiful.accent

	local date_bg = args.date_bg or beautiful.transparent
	local date_shape = args.date_shape
	local date_right = args.date_right
	local date_left = args.date_left
	local date_top = args.date_top
	local date_bottom = args.date_bottom

	local day_number_text_font = args.day_number_text_font or "JF Flat 50"
	local day_number_text_color = args.day_number_text_color or beautiful.accent

	local day_align = args.day_align or "center"
	local day_valign = args.day_valign or "center"

	local fuzzy_time_text_font = args.fuzzy_time_text_font or "JF Flat 18"
	local fuzzy_time_icon_font = args.fuzzy_time_icon_font or "Font Awesome 5 Free Solid 12"
	local fuzzy_time_fg_color = args.fuzzy_time_fg_color or beautiful.accent
	local fuzzy_time_bg_color = args.fuzzy_time_bg_color or beautiful.transparent
	local fuzzy_time_offset = args.fuzzy_time_offset or 0

	local fuzzy_time =
		helpers.add_text_icon_widget {
		text = "",
		icon = "",
		text_font = fuzzy_time_text_font,
		icon_font = fuzzy_time_icon_font,
		widget = wibox.widget.textbox,
		forced_width = dpi(200),
		forced_height = dpi(25)
	}

	local final =
		wibox.widget {
		layout = wibox.layout.fixed.vertical,
		forced_width = forced_width,
		{
			layout = wibox.layout.fixed.horizontal,
			---------------------------
			-------- معلومات الساعة --------
			---------------------------
			helpers.set_widget_block {
				widget = {
					layout = wibox.layout.manual,
					forced_height = dpi(0),
					{
						point = function(geo, args)
							return {
								x = args.parent.width - geo.width,
								y = 0
							}
						end,
						layout = wibox.layout.fixed.vertical,
						helpers.set_widget_block {
							widget = {
								text = "",
								font = day_text_font,
								id = "fuzzy_day",
								widget = wibox.widget.textbox
							},
							bg = beautiful.transparent,
							fg = day_text_color
						}
					},
					{
						point = function(geo, args)
							return {
								x = args.parent.width - geo.width,
								y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
							}
						end,
						layout = wibox.layout.fixed.vertical,
						helpers.set_widget_block {
							widget = {
								text = "",
								font = time_now_text_font,
								id = "time_now",
								widget = wibox.widget.textbox
							},
							bg = beautiful.transparent,
							top = tim_now_top,
							fg = day_text_color
						}
					},
					{
						point = function(geo, args)
							return {
								x = args.parent.width - geo.width,
								y = args.parent.height - geo.height
							}
						end,
						layout = wibox.layout.fixed.vertical,
						helpers.set_widget_block {
							widget = fuzzy_time,
							bg = beautiful.transparent,
							fg = day_text_color
						}
					}
				},
				right = clock_right,
				left = clock_left,
				top = clock_top,
				bottom = clock_bottom,
				forced_width = clock_forced_width,
				shape = clock_shape,
				bg = clock_bg
			},
			---------------
			-- الفاصل الطولي --
			---------------
			helpers.set_widget_block {
				widget = {
					text = "",
					widget = wibox.widget.textbox
				},
				shape = gears.shape.rectangle,
				bg = beautiful.accent,
				fg = beautiful.accent,
				right = separate_line,
				forced_height = line_forced_height,
				margin_left = line_margin_left,
				margin_right = line_margin_right
			},
			----------
			-- التاريخ --
			----------
			helpers.set_widget_block {
				widget = {
					layout = wibox.layout.fixed.vertical,
					helpers.set_widget_block {
						widget = {
							text = "",
							font = month_name_text_font,
							id = "month_name",
							-- align = "right",
							-- valign = "right",
							widget = wibox.widget.textbox
						},
						bg = beautiful.transparent,
						fg = month_name_text_color
					},
					helpers.set_widget_block {
						widget = {
							text = "",
							font = day_number_text_font,
							id = "day_number",
							align = day_align,
							valign = day_valign,
							widget = wibox.widget.textbox
						},
						bg = beautiful.transparent,
						fg = day_number_text_color
					}
				},
				right = date_right,
				left = date_left,
				top = date_top,
				bottom = date_bottom,
				shape = date_shape,
				bg = date_bg
			}
		}
	}

	watch(
		"date +%m-%d--%H:%M--%u%B",
		60,
		function(_, out)
			-- day of week (1..7); 1 is Monday
			local month, day, hours, minutes, week_number, month_name = out:match("^(%d%d)-(%d%d)--(%d%d):(%d%d)--(%d)(%S+)")

			final:get_children_by_id("day_number")[1]:set_text(day)

			final:get_children_by_id("month_name")[1]:set_text(month_name)

			if week_number == "1" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("واصل طريقك ")
			elseif week_number == "2" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("نصف الاسبوع ⌚")
			elseif week_number == "3" then
				-- final:get_children_by_id("line_margin")[1].left = dpi(50)
				final:get_children_by_id("fuzzy_day")[1]:set_text("باقي يومين ")
			elseif week_number == "4" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("ارررحب يالخميس 😉")
			elseif week_number == "5" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("عطلة 😍!")
			elseif week_number == "6" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("اسبوع جديد ")
			elseif week_number == "7" then
				final:get_children_by_id("fuzzy_day")[1]:set_text("استمر ")
			end

			if tonumber(hours) >= 0 and tonumber(hours) < 4 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("النوم")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("😴")
				fuzzy_time.forced_width = dpi(80 - fuzzy_time_offset)
			elseif tonumber(hours) >= 4 and tonumber(hours) < 9 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("صباح الخير")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(130 - fuzzy_time_offset)
			elseif tonumber(hours) >= 9 and tonumber(hours) < 12 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("الصبوح")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(95 - fuzzy_time_offset)
			elseif tonumber(hours) >= 12 and tonumber(hours) < 15 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("الغداء")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(85 - fuzzy_time_offset)
			elseif tonumber(hours) >= 15 and tonumber(hours) < 18 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("شاي بعد الغداء")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(190 - fuzzy_time_offset)
			elseif tonumber(hours) >= 18 and tonumber(hours) < 21 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("العشاء")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(95 - fuzzy_time_offset)
			elseif tonumber(hours) >= 21 then
				fuzzy_time:get_children_by_id("text_id")[1]:set_text("ليلة سعيدة")
				fuzzy_time:get_children_by_id("icon_id")[1]:set_text("")
				fuzzy_time.forced_width = dpi(140 - fuzzy_time_offset)
			end

			if tonumber(hours) > 12 then
				hours = tonumber(hours - 12)
			end
			final:get_children_by_id("time_now")[1]:set_text("الساعة الان " .. hours .. ":" .. minutes)
		end
	)

	return final
end

return worker
