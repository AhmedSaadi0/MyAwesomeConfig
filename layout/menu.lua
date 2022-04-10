local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        "المفاتيح",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {"الدليل", terminal .. " -e man awesome"},
    {"تعديل الاعدادات", editor_cmd .. " " .. awesome.conffile},
    {"اعادة تشغيل", awesome.restart},
    {
        "خروج",
        function()
            awesome.quit()
        end
    }
}

mymainmenu =
    awful.menu(
    {
        items = {
            {"اوسم", myawesomemenu, beautiful.awesome_icon},
            {"افتح الطرفية", terminal}
        }
    }
)

mylauncher =
    awful.widget.launcher(
    {
        image = beautiful.awesome_icon,
        menu = mymainmenu
    }
)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
