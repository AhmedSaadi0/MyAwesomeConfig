local awful = require("awful")
local gears = require("gears")
local ruled = require("ruled")
local beautiful = require("beautiful")
local client_keys = require("configuration.client.keys")
local client_buttons = require("configuration.client.buttons")

local tag_names = require("configuration.tags.tags")

ruled.client.connect_signal(
	"request::rules",
	function()
		-- All clients will match this rule.
		ruled.client.append_rule {
			id = "global",
			rule = {},
			properties = {
				focus = awful.client.focus.filter,
				raise = true,
				floating = false,
				maximized = false,
				above = false,
				below = false,
				ontop = false,
				sticky = false,
				maximized_horizontal = false,
				maximized_vertical = false,
				keys = client_keys,
				buttons = client_buttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen
			}
		}

		ruled.client.append_rule {
			id = "round_clients",
			rule_any = {
				type = {
					"normal",
					"dialog"
				}
			},
			except_any = {
				name = {"Discord Updater"}
			},
			properties = {
				round_corners = true,
				shape = beautiful.client_shape_rounded
			}
		}

		-- Titlebar rules
		ruled.client.append_rule {
			id = "titlebars",
			rule_any = {
				type = {
					"normal",
					"dialog",
					"modal",
					"utility"
				}
			},
			properties = {
				titlebars_enabled = false
			}
		}

		-- Dialogs
		ruled.client.append_rule {
			id = "dialog",
			rule_any = {
				type = {"dialog"},
				class = {"Wicd-client.py", "calendar.google.com"}
			},
			properties = {
				titlebars_enabled = false,
				floating = true,
				above = true,
				skip_decoration = true,
				placement = awful.placement.centered
			}
		}

		-- Glava
		
		ruled.client.append_rule {
			id = "glava",
			rule_any = {
				type = {"glava"},
				class = {"GLava"}
			},
			properties = {
				titlebars_enabled = false,
				switchtotag=true,
				floating = true,
				border_width = 0,
				above = false,
				skip_decoration = true,
				placement = awful.placement.bottom_right
			}
		}

		-- Modals
		ruled.client.append_rule {
			id = "modal",
			rule_any = {
				type = {"modal"}
			},
			properties = {
				titlebars_enabled = false,
				floating = true,
				above = true,
				skip_decoration = true,
				placement = awful.placement.centered
			}
		}

		-- Utilities
		ruled.client.append_rule {
			id = "utility",
			rule_any = {
				type = {"utility"}
			},
			properties = {
				titlebars_enabled = false,
				floating = true,
				skip_decoration = true,
				placement = awful.placement.centered
			}
		}

		-- Splash
		ruled.client.append_rule {
			id = "splash",
			rule_any = {
				type = {"splash"},
				name = {"Discord Updater"}
			},
			properties = {
				titlebars_enabled = false,
				round_corners = false,
				floating = true,
				above = true,
				skip_decoration = true,
				placement = awful.placement.centered
			}
		}

		-- Terminal emulators
		ruled.client.append_rule {
			id = "terminals",
			rule_any = {
				class = {
					"URxvt",
					"XTerm",
					"UXTerm",
					"kitty",
					"K3rmit",
					"gnome-terminal",
					"konsole"
				}
			},
			properties = {
				tag = tag_names[7],
				switch_to_tags = true,
				size_hints_honor = false,
				titlebars_enabled = false
			}
		}

		-- Browsers
		ruled.client.append_rule {
			id = "internet",
			rule_any = {
				class = {
					"firefox",
					"Tor Browser",
					"discord",
					"Chromium",
					"Google-chrome"
				}
			},
			properties = {
				tag = tag_names[6]
			}
		}

		-- Text editors and word processing
		ruled.client.append_rule {
			id = "text",
			rule_any = {
				class = {
					"Geany",
					"Atom",
					"Subl3",
					"code",
					"Code"
				},
				name = {
					"LibreOffice",
					"libreoffice"
				}
			},
			properties = {
				tag = tag_names[5]
			}
		}

		-- File managers
		ruled.client.append_rule {
			id = "files",
			rule_any = {
				class = {
					"dolphin",
					"ark",
					"Nemo",
					"File-roller"
				}
			},
			properties = {
				tag = tag_names[4],
				switch_to_tags = true
			}
		}

		-- Multimedia
		ruled.client.append_rule {
			id = "multimedia",
			rule_any = {
				class = {
					"vlc",
					"pragha",
					"Clementine",
					"Pulseeffects",
					"easyeffects",
					"mpv",
					"Genymotion",
					"systemsettings"
				}
			},
			properties = {
				tag = tag_names[1],
				switch_to_tags = true,
				placement = awful.placement.centered
			}
		}

		-- IDEs and Tools
		ruled.client.append_rule {
			id = "development",
			rule_any = {
				class = {
					"Oomox",
					"Unity",
					"UnityHub",
					"jetbrains-studio",
					"DBeaver",
					"Ettercap",
					"scrcpy"
				}
			},
			properties = {
				tag = tag_names[3],
				skip_decoration = true
			}
		}

		-- Social
		ruled.client.append_rule {
			id = "social",
			rule_any = {
				class = {
					"TelegramDesktop"
				}
			},
			properties = {
				tag = tag_names[2]
			}
		}

		-- Multimedia Editing
		-- ruled.client.append_rule {
		-- 	id = 'graphics',
		-- 	rule_any = {
		-- 		class = {
		-- 			'Gimp-2.10',
		-- 			'Inkscape',
		-- 			'Flowblade'
		-- 		}
		-- 	},
		-- 	properties = {
		-- 		tag = '7'
		-- 	}
		-- }

		-- Image viewers
		ruled.client.append_rule {
			id = "image_viewers",
			rule_any = {
				class = {
					"feh",
					"Pqiv",
					"Sxiv"
				}
			},
			properties = {
				titlebars_enabled = false,
				skip_decoration = true,
				floating = true,
				ontop = true,
				placement = awful.placement.centered
			}
		}

		-- Floating
		ruled.client.append_rule {
			id = "floating",
			rule_any = {
				instance = {
					"file_progress",
					"Popup",
					"Gcr-prompter",
					"nm-connection-editor"
				},
				class = {
					"scrcpy",
					"Mugshot",
					"krunner",
				},
				role = {
					"AlarmWindow",
					"ConfigManager",
					"pop-up"
				}
			},
			properties = {
				titlebars_enabled = false,
				skip_decoration = true,
				ontop = true,
				floating = true,
				focus = awful.client.focus.filter,
				raise = true,
				keys = client_keys,
				buttons = client_buttons,
				placement = awful.placement.centered
			}
		}
	end
)

-- Normally we'd do this with a rule, but some program like spotify doesn't set its class or name
-- until after it starts up, so we need to catch that signal.
client.connect_signal(
	"property::class",
	function(c)
		if c.class == "Spotify" then
			local window_mode = false

			-- Check if fullscreen or window mode
			if c.fullscreen then
				window_mode = false
				c.fullscreen = false
			else
				window_mode = true
			end

			-- Check if Spotify is already open
			local app = function(c)
				return ruled.client.match(c, {class = "Spotify"})
			end

			local app_count = 0
			for c in awful.client.iterate(app) do
				app_count = app_count + 1
			end

			-- If Spotify is already open, don't open a new instance
			if app_count > 1 then
				c:kill()
				-- Switch to previous instance
				for c in awful.client.iterate(app) do
					c:jump_to(false)
				end
			else
				-- Move the instance to specified tag on this screen
				local t = awful.tag.find_by_name(awful.screen.focused(), "5")
				c:move_to_tag(t)
				t:view_only()

				-- Fullscreen mode if not window mode
				if not window_mode then
					c.fullscreen = true
				else
					c.floating = true
					awful.placement.centered(c, {honor_workarea = true})
				end
			end
		end
	end
)
