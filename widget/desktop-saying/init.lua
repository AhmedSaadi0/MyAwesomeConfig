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
	local allow_scroll = args.allow_scroll or false

	local final = nil

	if allow_scroll then
		final =
			wibox.widget {
			layout = wibox.container.scroll.horizontal,
			-- max_size = 100,
			-- forced_height = dpi(5),
			fps = 60,
			step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
			speed = 100,
			id = "scroll_id",
			{
				text = "",
				font = wisdom_text_font,
				valign = valign,
				align = align,
				id = "wisdom",
				forced_height = forced_height,
				widget = wibox.widget.textbox
			}
		}
	else
		final =
			wibox.widget {
			text = "",
			font = wisdom_text_font,
			valign = valign,
			align = align,
			id = "wisdom",
			forced_width = forced_width,
			forced_height = forced_height,
			widget = wibox.widget.textbox
		}
	end

	final:connect_signal(
		"button::press",
		function()
			if allow_scroll then
				final:get_children_by_id("scroll_id")[1]:pause()
			end
			final:get_children_by_id("wisdom")[1]:set_text(words[math.random(#words)])
			if allow_scroll then
				final:get_children_by_id("scroll_id")[1]:continue()
			end
		end
	)

	watch(
		"echo 'hi'",
		3600,
		function(_, out)
			if allow_scroll then
				final:get_children_by_id("scroll_id")[1]:pause()
			end
			final:get_children_by_id("wisdom")[1]:set_text(words[math.random(#words)])
			if allow_scroll then
				final:get_children_by_id("scroll_id")[1]:continue()
			end
		end
	)

	return final
end

return worker
