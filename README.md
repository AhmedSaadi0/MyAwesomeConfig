# My Awesome config

# Install and use - التثبيت والاستخدام

### Required dependencies - البرامج المطلوبة

- awesome-git
- picom
- Rofi
- network-manager-applet
- xfce4-power-manager
- xfce4-screensaver
- brightnessctl
- light
- redshift
- playerctl
- polkit-kde-agent
- ttf-font-awesome-5
- xfce4-clipman
- qt5ct
- bandwhich
- jq
- Dolphin
- xorg-setxkbmap
- lightly-qt
- kvantum
- clementine
- qt5-gsettings
- lxappearance
- konsole
- gimp
- telegram-desktop
- blueman
- conky
- xcolor
- gufw

### Installation and usage - التثبيت والاستخدام

<b>Arch users - مستخدمي ارش </b>

    yay -S base-devel clementine brightnessctl light gimp network-manager-applet telegram-desktop awesome-git rofi xorg-xbacklight xorg-xrandr redshift qt5-gsettings lxappearance konsole xfce4-power-manager xfce4-screensaver blueman xorg-setxkbmap picom-git ark dolphin ffmpegthumbs playerctl lightly-qt kvantum polkit-kde-agent ttf-font-awesome-5 conky-lua jq xcolor light-git xclip gufw qt5ct xfce4-clipman tar

<b>Setting bandwhich to run without root - السماح لباند ويتش بالعمل بدون روت </b>

	sudo setcap cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep /usr/bin/bandwhich

<b>For animation use <a href="https://github.com/pijulius/picom"> pijulius picom fork </a></b>

<b>لاستخدام الانميشن استخدم <a href="https://github.com/pijulius/picom"> pijulius picom </a></b>


#### Setup - التثبيت
	git clone https://github.com/AhmedSaadi0/MyAwesomeConfig.git
	mv ~/.config/awesome/ ~/.config/awesome-old
	cp MyAwesomeConfig ~/.config/awesome
	mkdir ~/.config/rofi/
    cp ~/.config/awesome/rofi/config.rasi ~/.config/rofi/config.rasi
    cp ~/.config/awesome/themes/qt5/* ~/.config/qt5ct/
    cp -r ~/.config/awesome/themes/plasma-colors/* ~/.local/share/color-schemes
    cp -r ~/.config/awesome/themes/kvantum-themes/* ~/.config/Kvantum
    cp -r ~/.config/awesome/.fonts ~/
	sudo cp /etc/environment /etc/environmentOLD
	echo 'QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee -a /etc/environment
	mkdir ~/.local/share/icons
	tar xvf ~/.config/awesome/themes/sys-icons/Calm.tar.gz -C ~/.local/share/icons
	tar xvf ~/.config/awesome/themes/sys-icons/neon-icons-master.tar.gz -C ~/.local/share/icons
	tar xvf ~/.config/awesome/themes/sys-icons/NeonIcons.tar.gz -C ~/.local/share/icons
	tar xvf ~/.config/awesome/themes/sys-icons/Oreo-black-circle.tar.gz -C ~/.local/share/icons
	tar xvf ~/.config/awesome/themes/sys-icons/We10X.tar.gz -C ~/.local/share/icons
	glava --copy-config
	cp -r ~/.config/awesome/themes/glava/* ~/.config/glava/


# Screenshots - لقطات

<p align='center'>
	<img alt='screenshot 1' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/1.png'/>
</p>
<p align='center'>
	<img alt='screenshot 2' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/2.png'/>
</p>
<p align='center'>
	<img alt='screenshot 3' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/3.png'/>
</p>
<p align='center'>
	<img alt='screenshot 4' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/4.png'/>
</p>
<p align='center'>
	<img alt='screenshot 5' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/5.png'/>
</p>
<p align='center'>
	<img alt='screenshot 6' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/6.png'/>
</p>
<p align='center'>
	<img alt='screenshot 7' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/7.png'/>
</p>
<p align='center'>
	<img alt='screenshot 8' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/8.png'/>
</p>
<p align='center'>
	<img alt='screenshot 9' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/9.png'/>
</p>
<p align='center'>
	<img alt='screenshot 15' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/15.png'/>
</p>
<p align='center'>
	<img alt='screenshot 10' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/10.png'/>
</p>
<p align='center'>
	<img alt='screenshot 11' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/11.png'/>
</p>
<p align='center'>
	<img alt='screenshot 12' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/12.png'/>
</p>
<p align='center'>
	<img alt='screenshot 13' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/13.png'/>
</p>
<p align='center'>
	<img alt='screenshot 14' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/14.png'/>
</p>
<p align='center'>
	<img alt='screenshot 16' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/16.png'/>
</p>
<p align='center'>
	<img alt='screenshot 17' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/17.png'/>
</p>
<p align='center'>
	<img alt='screenshot 18' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/18.png'/>
</p>
<p align='center'>
	<img alt='screenshot Batman' src='https://github.com/AhmedSaadi0/MyAwesomeConfig/blob/master/screenshots/19.png'/>
</p>
