local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local watch = awful.widget.watch

local function worker(args)
	local full_shape = args.shape or helpers.rrect(beautiful.groups_radius)

	local text_font = args.text_font or beautiful.uifont
	local artist_font = args.artist_font
	local icon_font = args.icon_font or beautiful.iconfont
	local widget_bg = args.widget_bg or beautiful.widget_bg
	local widget_fg = args.widget_fg or beautiful.fg_normal
	local icon_bg = args.icon_bg
	local icon_fg = args.icon_fg

	local forced_width = args.forced_width
	local forced_height = args.forced_height or dpi(150)

	local margin_top = args.margin_top

	local bar_color = args.bar_color or beautiful.vol_bar_color
	local bar_active_color = args.bar_active_color or beautiful.vol_bar_active_color

	local inner_image_shape = args.shape or helpers.rrect(dpi(11))
	local buttons_group_shape = args.shape or helpers.rrect(dpi(11))
	local buttons_group_bg_color = args.buttons_group_bg_color or widget_bg
	local buttons_group_fg_color = args.buttons_group_fg_color or widget_fg

	local music =
		helpers.create_music_widget {
		text_font = text_font,
		icon_font = icon_font,
		widget_bg = widget_bg,
		widget_fg = widget_fg,
		icon_bg = icon_bg,
		artist_font = artist_font,
		icon_fg = icon_fg,
		margin_top = margin_top,
		bar_color = bar_color,
		bar_active_color = bar_active_color,
		inner_image_shape = inner_image_shape,
		buttons_group_shape = buttons_group_shape,
		buttons_group_bg_color = buttons_group_bg_color,
		buttons_group_fg_color = buttons_group_fg_color
	}
	local is_playing = false

	local final =
		helpers.set_widget_block {
		widget = music,
		shape = full_shape,
		bg = widget_bg,
		forced_height = forced_height,
		forced_width = forced_width
	}

	local function set_no_playing()
		music:get_children_by_id("title_id")[1].text = "لا توجد موسيقى قيد التشغيل"
		music:get_children_by_id("artist_id")[1].text = "لا يوجد فنان"
		music:get_children_by_id("play_button_id")[1].text = ""
		music:get_children_by_id("image_id")[1].image = beautiful.music_back
		is_playing = false
	end

	local function update_status(status)
		if string.find(status, "Playing") then
			music:get_children_by_id("play_button_id")[1].text = ""
			is_playing = true
		elseif string.find(status, "Paused") then
			music:get_children_by_id("play_button_id")[1].text = ""
			is_playing = false
		else
			set_no_playing()
		end
	end

	local changed = false

	music:get_children_by_id("progress")[1]:connect_signal(
		"property::value",
		function(_, new_value)
			if changed then
				local value = tonumber(new_value) / 1000000
				awful.spawn("playerctl position " .. value .. "", false)
				changed = false
			end
		end
	)

	music:connect_signal(
		"button::press",
		function()
			changed = true
			-- local value = music:get_children_by_id("progress")[1].value / 1000000
			-- -- awful.spawn("playerctl position " .. new_value .. "")
			-- awful.spawn("notify-send '" .. value .. "'")
		end
	)

	local function update_music_widget(title, artist, status, position, length, art_url)
		music:get_children_by_id("title_scroll_id")[1]:pause()
		music:get_children_by_id("artist_scroll_id")[1]:pause()

		local image_url = string.gsub(art_url:gsub("file://", ""), "^%s*(.-)%s*$", "%1")

		if string.gsub(title, "^%s*(.-)%s*$", "%1") == nil or string.gsub(title, "^%s*(.-)%s*$", "%1") == "" then
			music:get_children_by_id("title_id")[1].text = "لا يوجد عنوان"
		else
			music:get_children_by_id("title_id")[1].text = string.gsub(title, "^%s*(.-)%s*$", "%1")
		end

		if string.gsub(artist, "^%s*(.-)%s*$", "%1") == nil or string.gsub(artist, "^%s*(.-)%s*$", "%1") == "" then
			music:get_children_by_id("artist_id")[1].text = "لا يوجد فنان"
		else
			music:get_children_by_id("artist_id")[1].text = string.gsub(artist, "^%s*(.-)%s*$", "%1")
		end

		music:get_children_by_id("progress")[1].maximum = tonumber(length)
		music:get_children_by_id("progress")[1].value = tonumber(position)

		if image_url == "" then
			music:get_children_by_id("image_id")[1].image = beautiful.music_back
		else
			music:get_children_by_id("image_id")[1].image = image_url
		end

		update_status(status)

		music:get_children_by_id("title_scroll_id")[1]:continue()
		music:get_children_by_id("artist_scroll_id")[1]:continue()
	end

	music:get_children_by_id("play_button_id")[1]:connect_signal(
		"button::press",
		function()
			if is_playing then
				spawn.with_shell("playerctl pause")
				is_playing = false
				update_status("Paused")
			else
				spawn.with_shell("playerctl play")
				is_playing = true
				update_status("Playing")
			end
		end
	)

	music:get_children_by_id("stop_button_id")[1]:connect_signal(
		"button::press",
		function()
			spawn.with_shell("playerctl stop")
			is_playing = false
			update_status("stoped")
		end
	)

	music:get_children_by_id("next_button_id")[1]:connect_signal(
		"button::press",
		function()
			spawn.with_shell("playerctl next")
			is_playing = true
		end
	)

	music:get_children_by_id("back_button_id")[1]:connect_signal(
		"button::press",
		function()
			spawn.with_shell("playerctl previous")
			is_playing = true
		end
	)

	watch(
		"playerctl metadata --format '{{title}} ;; {{artist}} ;; {{album}} ;; {{status}} ;; {{position}} ;; {{mpris:length}} ;; {{mpris:artUrl}}'",
		1,
		function(_, stdout)
			if string.find(string.gsub(stdout, "^%s*(.-)%s*$", "%1"), "No player") then
				if is_playing then
					set_no_playing()
				end
				return
			elseif stdout == "" then
				if is_playing then
					set_no_playing()
				end
				return
			end

			local result = helpers.split(stdout, ";;")
			local title = ""
			local artist = ""
			local album = ""
			local status = ""
			local position = 0
			local length = 0
			local art_url = ""

			if result[1] then
				title = result[1]
			end
			if result[2] then
				artist = result[2]
			end
			if result[3] then
				album = result[3]
			end
			if result[4] then
				status = result[4]
			end
			if result[5] then
				position = result[5]
			end
			if result[6] then
				length = result[6]
			end
			if result[7] then
				art_url = result[7]
			end

			update_music_widget(title, artist, status, position, length, art_url)
		end
	)

	return final
end

return worker
