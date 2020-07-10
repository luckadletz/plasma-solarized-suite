# System theme meta-installer
# Luc Kadletz 2020

all: \
window-decorations \
cursor \
discord \
font \
gtk \
icons \
kvantum \
spotify \
theme-scheduler \
webapps

window-decorations : ./Aurorae
	# To apply window decorations just drop em in your home folder
	cp -rf Aurorae/Solarized-Sweet-Dark ~/.local/share/aurorae/themes/Solarized-Sweet-Dark
	cp -rf Aurorae/Solarized-Sweet-Light ~/.local/share/aurorae/themes/Solarized-Sweet-Light

cursor : ./Cursor
	# For cursors, you can put them in your home folder
	cp -rf Cursor/Vimix-cursors ~/.local/share/icons
	cp -rf Cursor/Vimix-white-cursors ~/.local/share/icons
	# But, cursors need to be system wide to work everywhere (???)
	sudo cp -rf Cursor/Vimix-cursors /usr/share/icons
	sudo cp -rf Cursor/Vimix-white-cursors /usr/share/icons

discord : ./Discord
	# TODO

font : ./Font
	# Dump _all_ the fonts into the system directory
	sudo cp -rf Font/fira-code/distr/ttf/*.ttf /usr/share/fonts/
	sudo cp -rf Font/encode-sans/*.ttf /usr/share/fonts/

gtk : ./Gtk
	# TODO

icons : ./Icons
	# Only copy the directories in Icons to ~/.
	cp --remove-destination -rt ~/.local/share/icons `find Icons -type d`

kvantum : ./Kvantum
	# TODO

spotify : ./Spotify
	# TODO

theme-scheduler : dependencies
	cd ThemeScheduler/Yin-Yang && sudo ./install.sh
	# It always says that, you have to check it yourself@echo...'

webapps : 
	$(MAKE) -C WebApps

dependencies :
	sudo apt install python3 python3-pip

remove-build-dependencies :
	apt remove python3-pip