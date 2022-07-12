local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local watch = awful.widget.watch

local function worker(args)
    local full_shape = args.shape or helpers.rrect(beautiful.groups_radius)

	local music = helpers.create_music_widget {}
    local is_playing = false

	local final =
        helpers.set_widget_block {
        widget = music,
        shape = full_shape,
        forced_height = dpi(130)
    }

	local function set_no_playing()
        music:get_children_by_id("title_id")[1].text  = "لا توجد موسيقى قيد التشغيل"
        music:get_children_by_id("artist_id")[1].text = "لا يوجد فنان"
        music:get_children_by_id("play_button_id")[1].text = ""
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

    local function update_music_widget(title, artist, status)
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

        update_status(status)
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
        "playerctl metadata --format '{{title}} ;; {{artist}} ;; {{album}} ;; {{status}}'",
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

            update_music_widget(title, artist, status)
        end
    )

	return final
end

return worker
