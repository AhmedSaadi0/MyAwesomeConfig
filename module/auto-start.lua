-- MODULE AUTO-START
-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require("awful")
local naughty = require("naughty")
local apps = require("configuration.apps")
local config = require("configuration.config")
local beautiful = require("beautiful")
-- local debug_mode = config.module.auto_start.debug_mode or false
local debug_mode = true

local run_once = function(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.easy_async_with_shell(
        string.format("pgrep -f -u $USER -x %s > /dev/null || (%s)", findme, cmd),
        function(stdout, stderr)
            -- Debugger
            if not stderr or stderr == "" or not debug_mode then
                return
            end
            naughty.notification(
                {
                    app_name = "<span font='" .. beautiful.appname_font .. "' >بدء تشغيل البرامج</span>",
                    title = "<span font='" ..
                        beautiful.title_font .. "' > عذرا! حدث خطأ اثناء بدء تشغيل البرنامج! </span>",
                    font = beautiful.uifont,
                    message = "-----------------------------------------\n البرنامج المحتمل : " .. findme .. "\n-----------------------------------------\n" .. stderr:gsub("%\n", ""),
                    timeout = 20,
                    icon = require("beautiful").awesome_icon
                }
            )
        end
    )
end

for _, app in ipairs(apps.run_on_start_up) do
    run_once(app)
end
