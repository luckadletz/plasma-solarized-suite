#!/bin/bash

install-webapp(){
	BUILD_DIR=$1 
	PUB_DIR=$2
	APP_NAME=$3

	echo "
===	Installing $APP_NAME	===
"

	echo "Finding $APP_NAME in $BUILD_DIR"
	APP_BUILD_DIR=$(find $BUILD_DIR -type d -name $APP_NAME\*)
	echo "Found $APP_BUILD_DIR"

	APP_PUB_DIR=$PUB_DIR/$(basename $APP_BUILD_DIR)

	echo "Publishing $APP_BUILD_DIR to $APP_PUB_DIR"
	if test -d $APP_PUB_DIR; then
		sudo rm -r $APP_PUB_DIR
	fi
	sudo cp -r $APP_BUILD_DIR $APP_PUB_DIR

	SANDBOX_PATH=$APP_PUB_DIR/chrome-sandbox
	echo "Setting permissions for $SANDBOX_PATH"
	echo chown root $SANDBOX_PATH
	sudo chown root $SANDBOX_PATH
	echo chmod 4755 $SANDBOX_PATH
	sudo chmod 4755 $SANDBOX_PATH

	DESKTOP_PATH=$APP_PUB_DIR/$APP_NAME.desktop
	echo "Copying desktop shortcut $DESKTOP_PATH"
	cp $DESKTOP_PATH ~/.local/share/applications/$APP_NAME.desktop

	if command -v $APP_NAME; then
		echo "$APP_NAME was already installed, skipping shortcut creation in /usr/bin"
	else
		echo "Creating shortcut in /usr/bin/$APP_NAME"
		sudo ln -s $APP_PUB_DIR/$APP_NAME /usr/bin/$APP_NAME
	fi
}


install-webapp $@