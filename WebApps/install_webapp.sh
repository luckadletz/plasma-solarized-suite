#!/bin/bash

ARCH="linux-x64" # Should match folder name pattern in APP_BUILD_DIR

install-webapp(){
	# The full path of the built app (First Arg)
	APP_BUILD_DIR=$1
	# The path that will contain all of our published webapps (Second Arg) 
	PUB_DIR=$2
	# The plain name of the app - found by stripping it from the build dir name
	APP_NAME=`echo $APP_BUILD_DIR | sed -r "s/.*\/(.+)-$ARCH/\1/g"`
	# The path of the app once it's published (we hope)
	APP_PUB_DIR=$PUB_DIR/$APP_NAME-$ARCH
	# The final app binary path (we hope)
	APP_BINARY=$APP_PUB_DIR/$APP_NAME
	# The pesky path to chrome sandbox we have to chown/chmod
	SANDBOX_PATH=$APP_PUB_DIR/chrome-sandbox
	# The path to the icon file
	ICON_PATH=$APP_PUB_DIR/resources/app/icon.png
	# The path of the desktop file
	DESKTOP_PATH=~/.local/share/applications/$APP_NAME.desktop

	echo "=== Installing $APP_NAME from $APP_BUILD_DIR -> $APP_PUB_DIR ==="

	echo "Publishing $APP_BUILD_DIR -> $PUB_DIR"

	sudo mkdir -p $PUB_DIR
	sudo cp -rf $APP_BUILD_DIR $PUB_DIR

	echo "=== Setting permissions for $SANDBOX_PATH ==="
	echo chown root $SANDBOX_PATH
	sudo chown root $SANDBOX_PATH
	echo chmod 4755 $SANDBOX_PATH
	sudo chmod 4755 $SANDBOX_PATH


	echo "=== Hacking together a desktop entry at $DESKTOP_PATH ==="
	echo "[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$APP_BINARY
Icon=$ICON_PATH
StartupNotify=true
Terminal=false
Categories=Internet
" > $DESKTOP_PATH


	echo "=== Creating shortcut in /usr/bin/$APP_NAME ==="
	sudo ln -sf $APP_PUB_DIR/$APP_NAME /usr/bin/$APP_NAME
}


install-webapp $@