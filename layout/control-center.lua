local gears = require("gears")
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local common = require("awful.widget.common")
local central_panel = require("layout.central-panel")

screen.connect_signal(
    "request::desktop_decoration",
    function(s)
        s.central_panel = central_panel(s)
    end
)

function check_panal(s)
    if s.central_panel == nil then
        s.central_panel = central_panel(s)
    end
end

-- Hide bars when app go fullscreen
function update_bars_visibility()
    for s in screen do
        if s.selected_tag then
            check_panal(s)

            local fullscreen = s.selected_tag.fullscreen_mode
            -- Order matter here for shadow
            if s.central_panel then
                if fullscreen and s.central_panel.visible then
                    s.central_panel:toggle()
                    s.central_panel_show_again = true
                elseif not fullscreen and not s.central_panel.visible and s.central_panel_show_again then
                    s.central_panel:toggle()
                    s.central_panel_show_again = false
                end
            end
        end
    end
end

tag.connect_signal(
    "property::selected",
    function(t)
        update_bars_visibility()
    end
)

client.connect_signal(
    "property::fullscreen",
    function(c)
        if c.first_tag then
            c.first_tag.fullscreen_mode = c.fullscreen
        end
        update_bars_visibility()
    end
)

client.connect_signal(
    "unmanage",
    function(c)
        if c.fullscreen then
            c.screen.selected_tag.fullscreen_mode = false
            update_bars_visibility()
        end
    end
)

-- awful.screen.connect_for_each_screen(
--     function(s)
--         -- Create the wibox
--         s.mywibox =
--             awful.wibar(
--             {
--                 position = "top",
--                 screen = s,
--                 height = beautiful.panal_hight,
--                 border_width = beautiful.panal_border_width,
--                 border_color = beautiful.bg_normal
--             }
--         )
--     end
-- )
