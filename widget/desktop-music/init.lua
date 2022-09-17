local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local watch = awful.widget.watch

local function worker(args)
	local title_font = args.title_font
	local artist_font = args.artist_font

	local widget_bg = args.widget_bg or beautiful.widget_bg
	local widget_artist_fg = args.widget_artist_fg or beautiful.fg_normal
	local widget_title_fg = args.widget_title_fg or beautiful.fg_normal

	local forced_width = args.forced_width

	local final =
		wibox.widget {
		layout = wibox.layout.fixed.vertical,
		forced_width = forced_width,
		helpers.set_widget_block {
			widget = {
				text = "",
				font = title_font,
				align = "left",
				valign = "left",
				id = "title",
				bg = widget_title_fg,
				widget = wibox.widget.textbox
			},
			bg = widget_bg,
			fg = widget_title_fg
		},
		helpers.set_widget_block {
			widget = {
				text = "",
				font = artist_font ,
				align = "left",
				valign = "left",
				id = "artist",
				bg = widget_artist_fg,
				widget = wibox.widget.textbox
			},
			top = dpi(10),
			bg = widget_bg,
			fg = widget_artist_fg
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
