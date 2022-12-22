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
	local forced_height = args.forced_height or dpi(70)

	local title_align = args.title_align
	local title_valign = args.title_valign or "center"

	local artist_align = args.artist_align
	local artist_valign = args.artist_valign or "center"

	local artist_forced_width = args.artist_forced_width
	local title_forced_width = args.title_forced_width

	local point =
		args.point or
		function(geo, args)
			return {
				x = args.parent.width - geo.width,
				y = (args.parent.height / 2 + (geo.height / 2)) - geo.height
			}
		end

	local final =
		wibox.widget {
		layout = wibox.layout.manual,
		forced_height = forced_height,
		forced_width = forced_width,
		{
			point = point,
			layout = wibox.layout.fixed.vertical,
			helpers.set_widget_block {
				widget = {
					layout = wibox.container.scroll.horizontal,
					-- max_size = 100,
					-- fps = 60,
					step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
					speed = 100,
					id = "title_scroll",
					{
						text = "",
						font = title_font,
						align = title_align,
						valign = title_valign,
						id = "music_title",
						bg = widget_title_fg,
						widget = wibox.widget.textbox
					}
				},
				bg = widget_bg,
				fg = widget_title_fg,
				forced_width = title_forced_width
			},
			helpers.set_widget_block {
				widget = {
					text = "",
					font = artist_font,
					align = artist_align,
					valign = artist_valign,
					id = "artist",
					bg = widget_artist_fg,
					widget = wibox.widget.textbox
				},
				top = dpi(10),
				bg = widget_bg,
				fg = widget_artist_fg,
				forced_width = artist_forced_width
			}
		}
	}

	local function update_widget(title, artist)
		final:get_children_by_id("title_scroll")[1]:pause()

		final:get_children_by_id("music_title")[1].text = ""
		final:get_children_by_id("music_title")[1].text = "لا يوجد عنوان"
		if string.gsub(title, "^%s*(.-)%s*$", "%1") == nil or string.gsub(title, "^%s*(.-)%s*$", "%1") == "" then
			final:get_children_by_id("music_title")[1].text = "لا يوجد عنوان"
		else
			final:get_children_by_id("music_title")[1].text = string.gsub(title, "^%s*(.-)%s*$", "%1")
		end

		if string.gsub(artist, "^%s*(.-)%s*$", "%1") == nil or string.gsub(artist, "^%s*(.-)%s*$", "%1") == "" then
			final:get_children_by_id("artist")[1].text = "لا يوجد فنان"
		else
			final:get_children_by_id("artist")[1].text = string.gsub(artist, "^%s*(.-)%s*$", "%1")
		end

		final:get_children_by_id("title_scroll")[1]:continue()
	end

	final:connect_signal(
		"button::press",
		function()
			awful.spawn.easy_async_with_shell(
				"playerctl metadata --format '{{title}} ;; {{artist}}'",
				function(stdout)
					final:get_children_by_id("title_scroll")[1]:pause()
					final:get_children_by_id("music_title")[1].text = ""
					final:get_children_by_id("music_title")[1].text = "لا يوجد عنوان"
					if string.find(string.gsub(stdout, "^%s*(.-)%s*$", "%1"), "No player could handle this command") or stdout == "" then
						update_widget("", "")
					else
						local result = helpers.split(stdout, ";;")
						update_widget(result[1], result[2])
					end
				end
			)
		end
	)

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
