local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local watch = require("awful").widget.watch
local words = require("widget.desktop-saying.words")
local awful = require("awful")

local function worker(args)
	local wisdom_text_font = args.wisdom_text_font or "JF Flat 14"

	local forced_width = args.forced_width
	local forced_height = args.forced_height
	local valign = args.valign
	local align = args.align

	local final =
		wibox.widget {
		text = "`",
		font = wisdom_text_font,
		valign = valign,
		align = align,
		id = "wisdom",
		forced_width = forced_width,
		forced_height = forced_height,
		widget = wibox.widget.textbox
	}

	final:connect_signal(
		"button::press",
		function()
			final:set_text(words[math.random(#words)])
		end
	)

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
