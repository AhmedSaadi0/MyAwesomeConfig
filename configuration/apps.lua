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
		-- Default text editor
		text_editor = "codium",
		-- text_editor = "code",
		-- Default file manager
		-- file_manager = "dolphin -reverse",
		file_manager = "pcmanfm-qt",
		-- Default media player
		multimedia = "clementine",
		-- Default chat app
		social = "telegram-desktop",
		-- Default IDE  
		-- LC_ALL=C prime-run studio
		development = "studio",
		-- Default locker
		-- lock = "/usr/lib/kscreenlocker_greet",
		lock = "xfce4-screensaver-command --lock",
		-- Default app menu
		rofi_appmenu = "rofi -dpi " .. screen.primary.dpi .. " -show drun"
	},
	-- List of apps to start once on start-up
	run_on_start_up = {
		"killall xsettingsd glava conky > /dev/null 2>&1",
		"nm-applet -sm-disable",
		"blueman-applet",
		"xfce4-clipman",
		-- "xclip",
		-- "xrandr --output eDP-1",
		-- "kded5",
		-- "/usr/lib/org_kde_powerdevil",
		"xfce4-power-manager",
		"xfce4-screensaver &> x.log",
		-- [[
		-- 	xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
		-- 	'xfce4-screensaver-command --lock' ""
		-- ]],
		"balooctl enable",
		'setxkbmap -layout "us,ar" -option "grp:win_space_toggle"',
		"/usr/lib/polkit-kde-authentication-agent-1",
		-- "/usr/lib/kactivitymanagerd",
		-- 		"xrandr --output HDMI-1-0 --mode 1440x900 --rate 61 --noprimary --left-of eDP-1",
		-- "picom -b --experimental-backends  --dbus --config " .. config_dir .. "/configuration/picom.conf",
		"picom --dbus --config " .. config_dir .. "/configuration/picom.conf",
		-- kvantum theme
		"kvantummanager --set " .. beautiful.kvantum_theme,
		-- PLasma theme
		config_dir .. "./bin/plasma-theme -c " .. config_dir .. "/themes/plasma-colors/" .. beautiful.plasma_color,
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
