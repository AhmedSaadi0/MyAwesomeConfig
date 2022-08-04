local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local watch = awful.widget.watch

local function worker(args)
	local text_font = args.font or beautiful.uifont

	local widget_bg = args.widget_bg or beautiful.widget_bg
	local widget_fg = args.widget_fg or beautiful.fg_normal

	local forced_width = args.forced_width

	local final =
		wibox.widget {
		layout = wibox.layout.fixed.vertical,
		forced_width = forced_width,
		helpers.set_widget_block {
			widget = {
				text = "",
				font = "JF Flat 20",
				align = "left",
				valign = "left",
				id = "title",
				bg = widget_fg,
				widget = wibox.widget.textbox
			},
			bg = widget_bg,
			fg = widget_fg
		},
		helpers.set_widget_block {
			widget = {
				text = "",
				font = "JF Flat 16",
				align = "left",
				valign = "left",
				id = "artist",
				bg = widget_fg,
				widget = wibox.widget.textbox
			},
			top = dpi(10),
			bg = widget_bg,
			fg = widget_fg
		}
	}

	local function update_widget(title, artist)
		if string.gsub(title, "^%s*(.-)%s*$", "%1") == nil or string.gsub(title, "^%s*(.-)%s*$", "%1") == "" then
			final:get_children_by_id("title")[1].text = "لا يوجد عنوان"
		else
			final:get_children_by_id("title")[1].text = string.gsub(title, "^%s*(.-)%s*$", "%1")
		end

		if string.gsub(artist, "^%s*(.-)%s*$", "%1") == nil or string.gsub(artist, "^%s*(.-)%s*$", "%1") == "" then
			final:get_children_by_id("artist")[1].text = "لا يوجد فنان"
		else
			final:get_children_by_id("artist")[1].text = string.gsub(artist, "^%s*(.-)%s*$", "%1")
		end
	end

	watch(
		"playerctl metadata --format '{{title}} ;; {{artist}}'",
		1,
		function(_, stdout)
			if string.find(string.gsub(stdout, "^%s*(.-)%s*$", "%1"), "No player could handle this command") or stdout == "" then
				update_widget("", "")
			else
				local result = helpers.split(stdout, ";;")
				update_widget(result[1], result[2])
			end
		end
	)

	return final
end

return worker
