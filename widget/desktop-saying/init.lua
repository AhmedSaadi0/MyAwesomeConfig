local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local watch = require("awful").widget.watch
local words = require("widget.desktop-saying.words")
local awful = require("awful")

local function worker(args)
	local wisdom_text_font = args.wisdom_text_font or "JF Flat 14"

	local final =
		wibox.widget {
		text = "",
		font = wisdom_text_font,
		align = "left",
		valign = "left",
		id = "wisdom",
		widget = wibox.widget.textbox
	}

	watch(
		"echo 'hi'",
		3600,
		function(_, out)
			final:set_text(words[math.random(#words)])
		end
	)

	return final
end

return worker
