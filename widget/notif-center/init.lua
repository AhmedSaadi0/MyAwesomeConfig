local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local beautiful = require("beautiful")

local notif_header =
	wibox.widget {
	text = "مركز الاشعارات",
	font = beautiful.uifont,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

local notif_center = function(s)
	s.dont_disturb = require("widget.notif-center.dont-disturb")
	s.clear_all = require("widget.notif-center.clear-all")
	s.notifbox_layout = require("widget.notif-center.build-notifbox").notifbox_layout

	return wibox.widget {
		{
			expand = "none",
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(10),
			{
				expand = "none",
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(5),
					s.dont_disturb,
					s.clear_all
				},
				nil,
				notif_header
			},
			s.notifbox_layout
		},
		left = dpi(0),
		right = dpi(8),
		widget = wibox.container.margin
	}
end

return notif_center
