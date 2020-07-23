# System theme meta-installer
# Luc Kadletz 2020


all: \
cursor \
discord \
font \
icons \
spotify \
kvantum \
window-decorations \
# gtk \
# theme-scheduler \
# webapps
	# S U C C E S S 

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
	
	# First we install Enhanced discord for custom theme support
	sudo cp -r ./Discord/EnhancedDiscord /opt
	# In ~/.config/discord/ find /x.x.xxx/modules/discord_desktop_core/index.js
	# TODO Insert this at the top of the file:
	# process.env.injDir = '/opt/EnhancedDiscord'; 
	# require(`${process.env.injDir}/injection.js`);

	# Now we install the glasscord estension for composition effects
	sudo mkdir -p /usr/share/discord/resources/app
	# Extract package.json file
	cd /usr/share/discord/resources && \
	sudo asar ef app.asar package.json && \
	sudo mv package.json ./app/package.json
	# Copy glasscord.asar to discord and inject into package.json
	sudo cp -f ./Discord/glasscord.asar /usr/share/discord/resources/app/
	# TODO replace   "main": "...", with "main": "./glasscord.asar"


font : ./Font
	# Dump _all_ the fonts into the system directory
	sudo mkdir -p /usr/share/fonts/truetype/fira-code /usr/share/fonts/truetype/encode-sans
	sudo cp -rf Font/fira-code/distr/ttf/*.ttf /usr/share/fonts/truetype/fira-code
	sudo cp -rf Font/encode-sans/*.ttf /usr/share/fonts/truetype/encode-sans
	# Rebuild the font cache
	fc-cache


fortune : ./Fortune/fortunes/*
	for FORTUNE in $^ ; do \
		./Fortune/install_fortune.sh $${FORTUNE} ; \
	done


gtk : ./Gtk
	# TODO GTK theme :)


grub : font
	# Mater - a utility to generate a minimal GRUB interface
	# We need to keep it around to regenerate on new kernels
	cd /opt && \
	sudo git clone https://github.com/mateosss/matter.git && \
	sudo chown $(USER):$(USER) mater  
	
	# WARNING: I'm assuming you have the same boot config as me
	sudo /opt/matter/matter.py \
	-i debian folder debian debian debian debian microsoft-windows cog \
	-ff /usr/share/fonts/truetype/fira-code/FiraCode-Bold.ttf -fn "Fira Code Bold" -fs 32 \
	-fg 839496 -bg 073642 -ic 93a1a1 -hl 2aa198

	# You can completely remove Matter from your system with ./matter.py -u


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


spicetify :
	# I'm assuming you installed spotify the same way I did :)
	# Install spicetify to change themes
	sudo mkdir -p /opt/spicetify-cli
	sudo chown ${USER}:${USER} /opt/spicetify-cli
	export SPICETIFY_INSTALL=/opt/spicetify-cli && \
	./Spotify/spicetify-cli/install.sh
	# add link to path
	sudo ln -sf /opt/spicetify-cli/spicetify /usr/bin/spicetify
	# Get permission to modify spotify files
	sudo chown ${USER}:${USER} /usr/share/spotify -R
	sudo chmod a+wr -R /usr/share/spotify -R
	# backup original spotify
	spicetify backup apply


spotify : ./Spotify
	# copy over theme files and apply
	mkdir -p ~/.config/spicetify/Themes
	cp -r ./Spotify/SolarizedDark ~/.config/spicetify/Themes
	spicetify config current_theme SolarizedDark
	spicetify apply


theme-scheduler :
	cd ThemeScheduler/Yin-Yang && sudo ./install.sh
	# It always says that, you have to check it yourself...


webapps : 
	$(MAKE) -C WebApps


window-decorations : ./Aurorae
	# To apply window decorations just drop em in your home folder
	mkdir -p ~/.local/share/aurorae/themes/
	cp -rf Aurorae/Solarized-Sweet-Dark ~/.local/share/aurorae/themes/Solarized-Sweet-Dark
	cp -rf Aurorae/Solarized-Sweet-Light ~/.local/share/aurorae/themes/Solarized-Sweet-Light
