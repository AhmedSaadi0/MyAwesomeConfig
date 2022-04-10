local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
require("awful.autofocus")
local modkey = require("configuration.keys.mod").mod_key
local altkey = require("configuration.keys.mod").alt_key

local client_keys =
	awful.util.table.join(
	awful.key(
		{modkey},
		"m",
		function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "تبديل ملئ الشاشة", group = "عميل"}
	),
	awful.key(
		{modkey},
		"q",
		function(c)
			c:kill()
		end,
		{
			description = "اغلاق",
			group = "عميل"
		}
	),
	awful.key({modkey}, "f", awful.client.floating.toggle, {description = "جعل النافذه عائمة", group = "عميل"}),
	awful.key(
		{modkey, "Control"},
		"Return",
		function(c)
			c:swap(awful.client.getmaster())
		end,
		{description = "الانتقال الى الرئيسي", group = "عميل"}
	),
	awful.key(
		{modkey},
		"o",
		function(c)
			c:move_to_screen()
		end,
		{
			description = "انقل الى الشاشة",
			group = "عميل"
		}
	),
	awful.key(
		{altkey, "Shift"},
		"a",
		function(c)
			c.ontop = not c.ontop
		end,
		{
			description = "انقل الى الشاشة",
			group = "Keep"
		}
	),
	awful.key(
		{modkey},
		"n",
		function(c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end,
		{description = "تصغير الى شريط المهام", group = "عميل"}
	)

	-- awful.key(
	-- 	{modkey},
	-- 	"m",
	-- 	function(c)
	-- 		c.maximized = not c.maximized
	-- 		c:raise()
	-- 	end,
	-- 	{description = "تكبير - تصغير", group = "عميل"}
	-- ),
	-- awful.key(
	-- 	{modkey, "Control"},
	-- 	"m",
	-- 	function(c)
	-- 		c.maximized_vertical = not c.maximized_vertical
	-- 		c:raise()
	-- 	end,
	-- 	{description = "تكبير - تصغير (عموديا)", group = "عميل"}
	-- ),
	-- awful.key(
	-- 	{modkey, "Shift"},
	-- 	"m",
	-- 	function(c)
	-- 		c.maximized_horizontal = not c.maximized_horizontal
	-- 		c:raise()
	-- 	end,
	-- 	{description = "تكبير - تصغير (افقياً)", group = "عميل"}
	-- )
	-- awful.key(
	-- 	{modkey},
	-- 	'd',
	-- 	function()
	-- 		awful.client.focus.byidx(1)
	-- 	end,
	-- 	{description = 'focus next by index', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'a',
	-- 	function()
	-- 		awful.client.focus.byidx(-1)
	-- 	end,
	-- 	{description = 'focus previous by index', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{ modkey, 'Shift'  },
	-- 	'd',
	-- 	function ()
	-- 		awful.client.swap.byidx(1)
	-- 	end,
	-- 	{description = 'swap with next client by index', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'u',
	-- 	awful.client.urgent.jumpto,
	-- 	{description = 'jump to urgent client', group = 'client'}
	-- ),
	-- ,awful.key(
	-- 	{modkey},
	-- 	'Tab',
	-- 	function()
	-- 		awful.client.focus.history.previous()
	-- 		if client.focus then
	-- 			client.focus:raise()
	-- 		end
	-- 	end,
	-- 	{description = 'go back', group = 'client'}
	-- )
	-- awful.key(
	--     {modkey},
	--     'n',
	--     function(c)
	--         c.minimized = true
	--     end,
	--     {description = 'minimize client', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{ modkey, 'Shift' },
	-- 	'c',
	-- 	function(c)
	-- 		local focused = awful.screen.focused()

	-- 		awful.placement.centered(c, {
	-- 			honor_workarea = true
	-- 		})
	-- 	end,
	-- 	{description = 'align a client to the center of the focused screen', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, 'Shift'},
	-- 	's',
	-- 	function(c)
	-- 		awful.util.spawn("plasma-open-settings")
	-- 	end,
	-- 	{description = 'move floating client up by 10 px', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'Up',
	-- 	function(c)
	-- 		c:relative_move(0, dpi(-10), 0, 0)
	-- 	end,
	-- 	{description = 'move floating client up by 10 px', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'Down',
	-- 	function(c)
	-- 		c:relative_move(0, dpi(10), 0, 0)
	-- 	end,
	-- 	{description = 'move floating client down by 10 px', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'Left',
	-- 	function(c)
	-- 		c:relative_move(dpi(-10), 0, 0, 0)
	-- 	end,
	-- 	{description = 'move floating client to the left by 10 px', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey},
	-- 	'Right',
	-- 	function(c)
	-- 		c:relative_move(dpi(10), 0, 0, 0)
	-- 	end,
	-- 	{description = 'move floating client to the right by 10 px', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, 'Shift'},
	-- 	'Up',
	-- 	function(c)
	-- 		c:relative_move(0, dpi(-10), 0, dpi(10))
	-- 	end,
	-- 	{description = 'increase floating client size vertically by 10 px up', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, 'Shift'},
	-- 	'Down',
	-- 	function(c)
	-- 		c:relative_move(0, 0, 0, dpi(10))
	-- 	end,
	-- 	{description = 'increase floating client size vertically by 10 px down', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, 'Shift'},
	-- 	'Left',
	-- 	function(c)
	-- 		c:relative_move(dpi(-10), 0, dpi(10), 0)
	-- 	end,
	-- 	{description = 'increase floating client size horizontally by 10 px left', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, 'Shift'},
	-- 	'Right',
	-- 	function(c)
	-- 		c:relative_move(0, 0, dpi(10), 0)
	-- 	end,
	-- 	{description = 'increase floating client size horizontally by 10 px right', group = 'client'}
	-- ),
	-- awful.key(
	-- 	{modkey, "Control"},
	-- 	"Up",
	-- 	function(c)
	-- 		if c.height > 10 then
	-- 			c:relative_move(0, 0, 0, dpi(-10))
	-- 		end
	-- 	end,
	-- 	{description = "decrease floating client size vertically by 10 px up", group = "client"}
	-- ),
	-- awful.key(
	-- 	{modkey, "Control"},
	-- 	"Down",
	-- 	function(c)
	-- 		local c_height = c.height
	-- 		c:relative_move(0, 0, 0, dpi(-10))
	-- 		if c.height ~= c_height and c.height > 10 then
	-- 			c:relative_move(0, dpi(10), 0, 0)
	-- 		end
	-- 	end,
	-- 	{description = "decrease floating client size vertically by 10 px down", group = "client"}
	-- ),
	-- awful.key(
	-- 	{modkey, "Control"},
	-- 	"Left",
	-- 	function(c)
	-- 		if c.width > 10 then
	-- 			c:relative_move(0, 0, dpi(-10), 0)
	-- 		end
	-- 	end,
	-- 	{description = "decrease floating client size horizontally by 10 px left", group = "client"}
	-- ),
	-- awful.key(
	-- 	{modkey, "Control"},
	-- 	"Right",
	-- 	function(c)
	-- 		local c_width = c.width
	-- 		c:relative_move(0, 0, dpi(-10), 0)
	-- 		if c.width ~= c_width and c.width > 10 then
	-- 			c:relative_move(dpi(10), 0, 0, 0)
	-- 		end
	-- 	end,
	-- 	{description = "decrease floating client size horizontally by 10 px right", group = "client"}
	-- )
)

return client_keys
