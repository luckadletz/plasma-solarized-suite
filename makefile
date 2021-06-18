# System theme meta-installer
# Luc Kadletz 2020
# TODO split up the theme stuff and the software stuff...

all: \
cursor \
discord \
font \
icons \
kvantum \
window-decorations 
# spotify \
# gtk \
# theme-scheduler \
# webapps

dependencies :
	sudo apt install python3 python3-pip npm
	sudo npm install -g --engine-strict asar
	make discord-extensions
	make spicetify

	sudo chmod +x ./Fortune/install_fortune.sh

clean :
	# Once everything is set up, you don't need any of these
	apt remove python3-pip nativefier npm


cursor : ./Cursor
	# For cursors, you can put them in your home folder
	cp -rf Cursor/Vimix-cursors ~/.local/share/icons
	cp -rf Cursor/Vimix-white-cursors ~/.local/share/icons
	# But, cursors need to be system wide to work everywhere (???)
	sudo cp -rf Cursor/Vimix-cursors /usr/share/icons
	sudo cp -rf Cursor/Vimix-white-cursors /usr/share/icons
	# Also, you have to set the gtk cursor to match...
	# Still not getting picked up on desktop, until it was???

discord : ./Discord/Themes
	# Applying discord themes (assuming you have EnhancedDiscord & glasscord)
	sudo cp -rf ./Discord/Themes /opt/EnhancedDiscord/
	# TODO go ahead and apply the theme with ctrl+r

discord-extensions : ./Discord/EnhancedDiscord ./Discord/glasscord.asar
	# I'm assuming you installed discord the same way I did :)
	# (with a .deb)
	# First we install Enhanced discord for custom theme support
	sudo cp -rf ./Discord/EnhancedDiscord /opt
	# In ~/.config/discord/ find /x.x.xxx/modules/discord_desktop_core/index.js
	# TODO Insert this at the top of the file:
	# process.env.injDir = '/opt/EnhancedDiscord'; 
	# require(`${process.env.injDir}/injection.js`);

	# Now we install the glasscord estension for composition effects
	sudo mkdir -p /opt/Discord/resources/app
	# Extract package.json file
	cd /opt/Discord/resources && 
	sudo asar ef app.asar package.json && \
	sudo mv package.json ./app/package.json
	# Copy glasscord.asar to discord and inject into package.json
	sudo cp -f ./Discord/glasscord.asar /opt/Discord/resources/app/
	# TODO replace   "main": "...", with "main": "./glasscord.asar" in /opt/Discord/resources/app/package.json
	sudo cp ./Discord/config.json /opt/EnhancedDiscord/config.json
	# TODO oops, I overwrote any EnhancedDiscord settings we had D:


font : ./Font
	# Dump _all_ the fonts into the system directory
	sudo mkdir -p /usr/share/fonts/truetype/fira-code /usr/share/fonts/truetype/encode-sans
	sudo cp -rf Font/fira-code/distr/ttf/*.ttf /usr/share/fonts/truetype/fira-code
	sudo cp -rf Font/encode-sans/*.ttf /usr/share/fonts/truetype/encode-sans
	# Rebuild the font cache
	fc-cache


cows : ./Cows
	sudo cp -rf $^/*.cow /usr/share/cowsay/cows

fortune : ./Fortune/fortunes/*
	for FORTUNE in $^ ; do \
		./Fortune/install_fortune.sh $${FORTUNE} ; \
	done
	# TODO belongs in ansible-homelab, not part of theme


gtk : ./Gtk
	# TODO GTK theme :)


grub : font
	# Matter - a utility to generate a minimal GRUB interface
	# We need to keep it around to regenerate on new kernels
	cd /opt && \
	sudo git clone https://github.com/mateosss/matter.git && \
	sudo chown $(USER):$(USER) matter  
	
	# WARNING: I'm assuming you have the same boot config as me
	sudo /opt/matter/matter.py \
	-i debian folder debian debian debian debian microsoft-windows cog \
	-ff /usr/share/fonts/truetype/fira-code/FiraCode-Bold.ttf -fn "Fira Code Bold" -fs 11 \
	-fg 839496 -bg 073642 -ic 93a1a1 -hl 2aa198

	# You can completely remove Matter from your system with ./matter.py -u

	# TODO Matter doesn't give you a background by default, use grub-customizer to
	# TODO Set GRUB_BACKGROUND="/boot/grub/themes/Matter/background.png" in /etc/default/grub
	# TODO Also, have to tweak the debian bootstrapper to share bg
	
	# TODO Better yet, just save the modified config and install (still need matter for updates)

	# TODO Set the plymouth theme to a custom one

icons : ./Icons
	# Copy the directories in Icons to user icons, this may take a while...
	cp --remove-destination -rt ~/.local/share/icons `find Icons -type d`


kvantum : ./Kvantum
	cp -rf Kvantum/Solarized-Sweet-Dark ~/.config/Kvantum/
	cp -rf Kvantum/Solarized-Sweet-Light ~/.config/Kvantum/


plasma : ./Plasma
	# ~/.local/share/plasma/desktoptheme
	cp -rf Plasma/Sweet-Solarized-Dark ~/.local/share/plasma/desktoptheme
	cp -rf Plasma/Sweet-Solarized-Light ~/.local/share/plasma/desktoptheme


sound : ./Sound
	# Copying sounds to /usr/share/sound
	# You can put whatever .ogg here
	sudo cp --remove-destination -rft /usr/share/sounds `find ./Sound/ -type d`
	# Change sounds in System Settings -> Personalization -> Notifications -> Plasma Workspace


# spicetify :
	# # I'm assuming you installed spotify the same way I did :)
	# # Install spicetify to change themes
	# sudo mkdir -p /opt/spicetify-cli
	# sudo chown ${USER}:${USER} /opt/spicetify-cli
	# export SPICETIFY_INSTALL=/opt/spicetify-cli && \
	# ./Spotify/spicetify-cli/install.sh
	# # add link to path
	# sudo ln -sf /opt/spicetify-cli/spicetify /usr/bin/spicetify
	# # Get permission to modify spotify files
	# sudo chown ${USER}:${USER} /usr/share/spotify -R
	# sudo chmod a+wr -R /usr/share/spotify -R
	# # backup original spotify
	# spicetify backup apply


spotify : ./Spotify
	# copy over theme files and apply
	mkdir -p ~/.config/spicetify/Themes
	cp -r ./Spotify/SolarizedDark ~/.config/spicetify/Themes
	spicetify config current_theme SolarizedDark
	spicetify apply


spotify-cli : 
	# TODO belongs in ansible-homelab, not part of theme
	# This one is for calling play / pause / whatever on cli
	pip install spotify-cli-linux
	# This one is for looking cool and going fast B)
	sudo mkdir /opt/spotify-tui
	curl https://github.com/Rigellute/spotify-tui/releases/download/v0.21.0/spotify-tui-linux.tar.gz
	# I don't think that that curl command works ...

touchpad-gestures :
	sudo gpasswd -a $(USER) input
	git clone https://github.com/bulletmark/libinput-gestures.git
	sudo make -C libinput-gestures install
	libinput-gestures-setup autostart
	libinput-gestures-setup start
	# TODO this def doesn't belong in my theme stuff
	# Also, it uses the working directory as a build staging dir and doesn't clean up



theme-scheduler :
	cd ThemeScheduler/Yin-Yang && sudo ./install.sh
	# It always says that, you have to check it yourself...


webapps : 
	$(MAKE) -C WebApps dev
	$(MAKE) -C WebApps all
	$(MAKE) -C WebApps install
	# TODO WebApps is a better fit for the ansible project (and should prob be it's own submodule)

window-decorations : ./Aurorae
	# To apply window decorations just drop em in your home folder
	mkdir -p ~/.local/share/aurorae/themes/
	cp -rf Aurorae/Solarized-Sweet-Dark ~/.local/share/aurorae/themes/Solarized-Sweet-Dark
	cp -rf Aurorae/Solarized-Sweet-Light ~/.local/share/aurorae/themes/Solarized-Sweet-Light
