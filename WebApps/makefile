# Custom Nativefier web apps for Luc Kadletz

BUILD_DIR = ./build
PUB_DIR = /opt

OPTIONS = -n $@ \
--browserwindow-options '{"webPreferences":{"sandbox":false}}'\
--disable-dev-tools \
--single-instance \
# --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/999 Safari/537.36"
# --internal-urls ".*?" \

APPS = my-noise pomodoro google-calendar roll-20 \
trello todoist google-mail proton-mail \
plex youtube amazon brainaural \
khan-academy wikipedia wolfram

BETA_APPS = netflix microsoft-office google-drive

MEH_APPS = mit-open-courseware intuit-mint 

all : $(APPS)

install : 
	$(foreach app, $(APPS), ./install_webapp.sh $(BUILD_DIR) $(PUB_DIR) $(app);)

uninstall :
	$(foreach app, $(APPS), sudo rm -i  /usr/bin/$(app);)
	# TODO actually clean up the published folders in /opt/

dev :
	sudo apt install npm
	sudo npm install -g nativefier
	sudo chmod +x ./install_webapp.sh

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
	nativefier $(OPTIONS) --internal-urls ".*?(google|trello|atlassian).*?" \
	https://trello.com/luckadletz/boards $(BUILD_DIR)

todoist : 
	nativefier $(OPTIONS) --internal-urls ".*?(google|todoist).*?" \
	https://todoist.com/app/#start $(BUILD_DIR)

google-mail : 
	nativefier $(OPTIONS) --counter \
	https://mail.google.com/mail/u/0/#inbox $(BUILD_DIR)

proton-mail :
	nativefier $(OPTIONS) --counter \
	https://mail.protonmail.com/inbox $(BUILD_DIR)

netflix :
	nativefier $(OPTIONS) https://www.netflix.com/browse $(BUILD_DIR)

plex : 
	nativefier $(OPTIONS) https://app.plex.tv/desktop $(BUILD_DIR)

twitch-tv:
	nativefier $(OPTIONS) https://www.twitch.tv/directory $(BUILD_DIR)

roll-20 :
	nativefier $(OPTIONS) https://app.roll20.net $(BUILD_DIR)

wikipedia :
	nativefier $(OPTIONS) https://en.wikipedia.org/wiki/Main_Page $(BUILD_DIR)

intuit-mint :
	nativefier $(OPTIONS) https://mint.intuit.com/overview.event $(BUILD_DIR)

wolfram : 
	nativefier $(OPTIONS) https://www.wolframalpha.com/ $(BUILD_DIR)

youtube : 
	nativefier $(OPTIONS) https://www.youtube.com/ $(BUILD_DIR)

amazon :
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