local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. "utilities/"
local beautiful = require("beautiful")

return {
	-- The default applications that we will use in keybindings and widgets
	default = {
		-- Default terminal emulator
		terminal = "konsole " .. beautiful.konsole_profile,
		-- Default web browser
		web_browser = "firefox",
		-- web_browser = "brave",
		-- Default text editor
		text_editor = "code",
		-- text_editor = "code",
		-- Default file manager
		file_manager = "dolphin -reverse",
		-- file_manager = "pcmanfm-qt",
		-- Default media player
		multimedia = "strawberry",
		-- multimedia = "amarok -reverse",
		-- Default chat app
		social = "telegram-desktop",
		-- Default IDE  
		-- LC_ALL=C prime-run studio
		development = "export LANG=en_US.UTF-8 && studio",
		-- Games
		games = "retroarch",
		-- Default locker
		-- lock = "/usr/lib/kscreenlocker_greet",
		lock = "xfce4-screensaver-command --lock",
		-- Default app menu
		rofi_appmenu = "rofi -dpi " .. screen.primary.dpi .. " -show drun"
	},
	-- List of apps to start once on start-up
	run_on_start_up = {
		"killall xfce4-notifyd xsettingsd glava conky > /dev/null 2>&1",
		"nm-applet -sm-disable",
		"blueman-applet",
		"xfce4-clipman",
		-- "xclip",
		-- "xrandr --output eDP-1",
		-- "kded5",
		-- "/usr/lib/org_kde_powerdevil",
		-- "lxqt-powermanagement",
		"killall kdeconnect-indicator && sleep 10 ; kdeconnect-indicator &",
		"xfce4-power-manager",
		"xfce4-screensaver > /dev/null 2>&1",
		-- "balooctl enable",
		'setxkbmap -layout "us,ara" -option "grp:win_space_toggle"',
		"/usr/lib/polkit-kde-authentication-agent-1",
		"picom -b --dbus --config " .. config_dir .. "/configuration/picom.conf > /dev/null 2>&1",
		-- "picom -b --dbus --config " .. config_dir .. "/configuration/picom.conf",
		-- kvantum theme
		"kvantummanager --set " .. beautiful.kvantum_theme,
		-- PLasma theme
		"plasma-apply-colorscheme " .. beautiful.plasma_color,
		-- "kwriteconfig5 --file ~/.config/kcminputrc --group Mouse --key cursorTheme " .. beautiful.plasma_cursors,
		"kcminit",
		config_dir .. beautiful.conky_script .." > /dev/null 2>&1",
		-- QT Icons
		'sed -i "s/icon_theme=.*/icon_theme='.. beautiful.qt_icon_theme ..'/g" ~/.config/qt5ct/qt5ct.conf',
		"sed -i 's/icon-theme:.*/icon-theme:\"" .. beautiful.qt_icon_theme .. "\"; /g' ~/.config/rofi/config.rasi",
		-- QT Style
		'sed -i "s/style=.*/style='.. beautiful.qt_style_theme ..'/g" ~/.config/qt5ct/qt5ct.conf',
		-- GTK Theme
		[[sed -i 's/Net\/ThemeName.*/Net\/ThemeName "]] .. beautiful.gtk_theme .. [["/g' ~/.config/xsettingsd/xsettingsd.conf]],
		'sed -i "s/gtk-theme-name=.*/gtk-theme-name='.. beautiful.gtk_theme ..'/g" ~/.config//gtk-3.0/settings.ini',
		[[sed -i 's/Net\/IconThemeName.*/Net\/IconThemeName "]] .. beautiful.qt_icon_theme .. [["/g' ~/.config/xsettingsd/xsettingsd.conf]],
		"xsettingsd",
	},
	-- List of binaries/shell scripts that will execute for a certain task
	utils = {
		-- Fullscreen screenshot
		full_screenshot = utils_dir .. "snap full",
		-- Area screenshot
		area_screenshot = utils_dir .. "snap area",
		-- Update profile picture
		update_profile = utils_dir .. "profile-image"
	}
}
