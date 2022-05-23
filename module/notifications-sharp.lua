local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "اشعارات النظام"
-- naughty.config.defaults.margin = dpi(160)
naughty.config.defaults.border_width = 1
naughty.config.defaults.border_color = beautiful.notification_border_focus
naughty.config.defaults.position = "bottom_left"
-- naughty.config.defaults.shape = function(cr, w, h)
-- 	gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
-- end
naughty.config.defaults.shape = gears.shape.rectangle

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
	"/usr/share/icons/Tela",
	"/usr/share/icons/Tela-blue-dark",
	"/usr/share/icons/Papirus/",
	"/usr/share/icons/la-capitaine-icon-theme/",
	"/usr/share/icons/gnome/",
	"/usr/share/icons/hicolor/",
	"/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"svg", "png", "jpg", "gif"}

-- Presets / rules

ruled.notification.connect_signal(
	"request::rules",
	function()
		-- Critical notifs
		ruled.notification.append_rule {
			rule = {urgency = "critical"},
			properties = {
				-- font        		= 'JF Flat 10',
				bg = beautiful.notification_bg,
				fg = beautiful.fg_normal,
				-- margin = dpi(16),
				position = "bottom_left",
				implicit_timeout = 0
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule = {urgency = "normal"},
			properties = {
				-- font        		= 'JF Flat 10',
				bg = beautiful.notification_bg,
				fg = beautiful.fg_normal,
				-- margin = dpi(16),
				position = "bottom_left",
				implicit_timeout = 5
			}
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule = {urgency = "low"},
			properties = {
				-- font        		= 'JF Flat 10',
				bg = beautiful.notification_bg,
				fg = beautiful.fg_normal,
				-- margin = dpi(16),
				position = "bottom_left",
				implicit_timeout = 5
			}
		}
	end
)

-- Error handling
naughty.connect_signal(
	"request::display_error",
	function(message, startup)
		naughty.notification {
			urgency = "critical",
			title = "عذرا. حدث خطأ" .. (startup and " اثناء بدء التشغيل!" or "!"),
			message = message,
			app_name = "اعدادت النظام",
			icon = beautiful.awesome_icon
		}
	end
)

-- XDG icon lookup
naughty.connect_signal(
	"request::icon",
	function(n, context, hints)
		if context ~= "app_icon" then
			return
		end

		local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

		if path then
			n.icon = path
		end
	end
)

-- Connect to naughty on display signal
naughty.connect_signal(
	"request::display",
	function(n)
		-- Actions Blueprint
		local actions_template =
			wibox.widget {
			notification = n,
			base_layout = wibox.widget {
				spacing = dpi(0),
				layout = wibox.layout.flex.horizontal
			},
			widget_template = {
				{
					{
						{
							{
								id = "text_role",
								font = beautiful.uifont,
								widget = wibox.widget.textbox
							},
							widget = wibox.container.place
						},
						widget = clickable_container
					},
					bg = beautiful.groups_bg,
					shape = gears.shape.rectangle,
					-- shape = function(cr, w, h)
					-- 	gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
					-- end,
					forced_height = dpi(30),
					widget = wibox.container.background
				},
				margins = dpi(4),
				widget = wibox.container.margin
			},
			style = {underline_normal = false, underline_selected = true},
			widget = naughty.list.actions
		}

		-- Notifbox Blueprint
		naughty.layout.box {
			notification = n,
			type = "notification",
			margins = 30,
			screen = awful.screen.preferred(),
			shape = gears.shape.rectangle,
			-- shape = function(cr, w, h)
			-- 	gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			-- end,
			widget_template = {
				{
					{
						{
							{
								{
									{
										{
											{
												-- The title
												{
													{
														markup = n.app_name or "اشعارات النظام",
														font = beautiful.uifont,
														align = "center",
														valign = "center",
														widget = wibox.widget.textbox
													},
													margins = beautiful.notification_title_margin,
													widget = wibox.container.margin
												},
												bg = beautiful.notification_title_color,
												widget = wibox.container.background
											},
											{
												-- The body
												{
													-- The icon
													{
														resize_strategy = "center",
														widget = naughty.widget.icon
													},
													margins = beautiful.notification_icon_margin,
													widget = wibox.container.margin
												},
												{
													-- The text body
													{
														layout = wibox.layout.align.vertical,
														expand = "none",
														nil,
														{
															{
																-- Message title
																align = "left",
																widget = naughty.widget.title
															},
															{
																-- Message text
																align = "left",
																widget = naughty.widget.message
															},
															layout = wibox.layout.fixed.vertical
														},
														nil
													},
													left = beautiful.notification_body_left_margin,
													right = beautiful.notification_body_right_margin,
													top = beautiful.notification_body_top_margin,
													bottom = beautiful.notification_body_bottom_margin,
													widget = wibox.container.margin
												},
												layout = wibox.layout.fixed.horizontal
											},
											fill_space = true,
											-- spacing = beautiful.notification_body_margin,
											layout = wibox.layout.fixed.vertical
										},
										-- Margin between the fake background
										-- Set to 0 to preserve the 'titlebar' effect
										margins = beautiful.notification_body_margins,
										widget = wibox.container.margin
									},
									bg = beautiful.notification_bg,
									widget = wibox.container.background
								},
								-- Actions
								actions_template,
								spacing = dpi(4),
								layout = wibox.layout.fixed.vertical
							},
							bg = beautiful.notification_bg,
							id = "background_role",
							widget = naughty.container.background
						},
						strategy = "min",
						width = dpi(160),
						widget = wibox.container.constraint
					},
					strategy = "max",
					width = beautiful.notification_max_width or dpi(500),
					widget = wibox.container.constraint
				},
				bg = beautiful.bg_normal,
				shape = gears.shape.rectangle,
				-- shape = function(cr, w, h)
				-- 	gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
				-- end,
				widget = wibox.container.background
			}
		}

		-- Destroy popups if dont_disturb mode is on
		-- Or if the right_panel is visible
		local focused = awful.screen.focused()
		if _G.dont_disturb or (focused.right_panel and focused.right_panel.visible) then
			naughty.destroy_all_notifications(nil, 1)
		end
	end
)
