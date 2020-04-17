# Custom Nativefier web apps for Luc Kadletz

BG_COLOR = 07364233

BUILD_DIR = ./build
PUB_DIR = /opt

OPTIONS = -n $@ \
--browserwindow-options '{"webPreferences":{"sandbox":false}}' \
--background-color $(BG_COLOR)
# --internal-urls ".*?" \

APPS = my-noise pomodoro google-calendar trello google-mail proton-mail \
netflix plex wikipedia wolfram youtube shop-amazon brainaural google-drive \
microsoft-office khan-academy mit-open-courseware

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

wikipedia :
	nativefier $(OPTIONS) https://en.wikipedia.org/wiki/Main_Page $(BUILD_DIR)

intuit-mint :
	nativefier $(OPTIONS) https://mint.intuit.com/overview.event $(BUILD_DIR)

wolfram : 
	nativefier $(OPTIONS) https://www.wolframalpha.com/ $(BUILD_DIR)

youtube : 
	nativefier $(OPTIONS) https://www.youtube.com/ $(BUILD_DIR)

shop-amazon :
	nativefier $(OPTIONS) https://smile.amazon.com/ $(BUILD_DIR)

brainaural :
	nativefier $(OPTIONS) https://brainaural.com/ $(BUILD_DIR)

google-drive :
	nativefier $(OPTIONS) --internal-urls ".*?(google|drive).*?" \
	https://drive.google.com/drive/my-drive $(BUILD_DIR)

microsoft-office :
	nativefier $(OPTIONS) --internal-urls ".*?(office|live|onedrive|onenote|).*?" \
	https://www.office.com/?auth=1 $(BUILD_DIR)

khan-academy :
	nativefier $(OPTIONS) https://www.khanacademy.org/ $(BUILD_DIR)

mit-open-courseware : 
	nativefier $(OPTIONS) https://ocw.mit.edu/courses/ $(BUILD_DIR)