# Custom Nativefier web apps for Luc Kadletz

BG_COLOR = 07364233
OPTIONS = -n $@ -u luc --browserwindow-options '{"webPreferences":{"sandbox":false}}' --background-color $(BG_COLOR)
BUILD_DIR = ./build
PUB_DIR = /opt

APPS = my-noise pomodoro google-calendar trello google-mail proton-mail netflix plex wolfram youtube shop-amazon

all : $(APPS)

install : 
	$(foreach app, $(APPS), ./install_webapp.sh $(BUILD_DIR) $(PUB_DIR) $(app);)

uninstall :
	$(foreach app, $(APPS), sudo rm -i  /usr/bin/$(app);)
	#Does not yet clean up the published folders in /opt/
	
clean : 
	rm -r $(BUILD_DIR)

my-noise : 
	nativefier $(OPTIONS) --width 900 --height 900 \
	https://mynoise.net/noiseMachines.php $(BUILD_DIR)

pomodoro : 
	nativefier $(OPTIONS) --width 600 --height 400 --zoom 0.9 --counter --single-instance \
	https://tomato-timer.com/ $(BUILD_DIR)

google-calendar :
	nativefier $(OPTIONS) --counter --single-instance \
	https://calendar.google.com/calendar/r $(BUILD_DIR)

trello :
	nativefier $(OPTIONS) https://trello.com/luckadletz/boards $(BUILD_DIR)

google-mail : 
	nativefier $(OPTIONS) --counter \
	https://mail.google.com/mail/u/0/#inbox $(BUILD_DIR)

proton-mail :
	nativefier $(OPTIONS) --counter \
	https://mail.protonmail.com/inbox $(BUILD_DIR)

netflix :
	nativefier $(OPTIONS) --single-instance \
	https://www.netflix.com/browse $(BUILD_DIR)

plex : 
	nativefier $(OPTIONS) --single-instance \
	https://app.plex.tv/desktop $(BUILD_DIR)

wolfram : 
	nativefier $(OPTIONS) https://www.wolframalpha.com/ $(BUILD_DIR)

youtube : 
	nativefier $(OPTIONS) --single-instance \
	https://www.youtube.com/ $(BUILD_DIR)

shop-amazon :
	nativefier $(OPTIONS) https://smile.amazon.com/ $(BUILD_DIR)