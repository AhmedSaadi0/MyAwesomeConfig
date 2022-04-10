pcall(require, ".loader")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")

local awful = require("awful")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify(
        {
            preset = naughty.config.presets.critical,
            title = "عذراً حدث خطأ اثناء بدء التشغيل!",
            text = awesome.startup_errors
        }
    )
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        "debug::error",
        function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then
                return
            end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = "عذراً حدث خطأ!",
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

-- This is used later as the default terminal and editor to run.
awful.util.shell = 'sh'

terminal = "konsole"
editor = os.getenv("EDITOR") or "kate"
editor_cmd = terminal .. " -e " .. editor

