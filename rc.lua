local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

require("init")

-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/theme_circles.lua")

require("layout.init")

-- require("ui.control-center")

require("configuration.client")
require("configuration.root")
require("configuration.tags")
root.keys(require("configuration.keys.global"))

-- ░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░█▀▀
-- ░█░█░█░█░█░█░█░█░█░░░█▀▀░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀

require("module.notifications")
require("module.auto-start")
require("module.dynamic-wallpaper")
require("module.exit-screen")
require("module.brightness-osd")
require("module.volume-osd")

-- require('module.menu')
-- require('module.quake-terminal')
-- require('module.titlebar')
-- require("autustart")

-- ░█░█░█▀█░█░░░█░░░█▀█░█▀█░█▀█░█▀▀░█▀▄
-- ░█▄█░█▀█░█░░░█░░░█▀▀░█▀█░█▀▀░█▀▀░█▀▄
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀░░░▀▀▀░▀░▀

screen.connect_signal(
	"request::wallpaper",
	function(s)
		-- If wallpaper is a function, call it with the screen
		if beautiful.wallpaper then
			if type(beautiful.wallpaper) == "string" then
				-- Check if beautiful.wallpaper is color/image
				if beautiful.wallpaper:sub(1, #"#") == "#" then
					-- If beautiful.wallpaper is color
					gears.wallpaper.set(beautiful.wallpaper)
				elseif beautiful.wallpaper:sub(1, #"/") == "/" then
					-- If beautiful.wallpaper is path/image
					gears.wallpaper.maximized(beautiful.wallpaper, s)
				end
			else
				beautiful.wallpaper(s)
			end
		end
	end
)
