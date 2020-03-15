/*
 *
 * @licstart  The following is the entire license notice for the 
 *  JavaScript code in this page.
 *
 * Copyright (C) 2018 Jaume Fuster i Claris
 *
 *
 * The JavaScript code in this page is free software: you can
 * redistribute it and/or modify it under the terms of the GNU
 * General Public License (GNU GPL) as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version.  The code is distributed WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU GPL for more details.
 *
 * As additional permission under GNU GPL version 3 section 7, you
 * may distribute non-source (e.g., minimized or compacted) forms of
 * that code without the copy of the GNU GPL normally required by
 * section 4, provided you include this license notice and a URL
 * through which recipients can access the Corresponding Source.
 *
 * @licend  The above is the entire license notice
 * for the JavaScript code in this page.
 *
 */

// "Thus, programs must be written for people to read, and only incidentally for machines to execute."
// TODO: Commenting.


// ---------- CONFIGURATION ----------

// div.innerHTML : {a.innerHTML : a.href}
var sites = {
			"Social": {
				"Reddit"			: "https://reddit.com",
				"Twitter"			: "https://twitter.com/",
				"LinkedIn"			: "https://www.linkedin.com/",
				"GMail"				: "https://mail.google.com/mail/u/0/",
				"ProtonMail"		: "https://mail.protonmail.com/inbox",
			},

			"Noise": {
				"MyNoise"			: "https://mynoise.net/noiseMachines.php",
				"City Rain"			: "https://mynoise.net/NoiseMachines/customRainInTheCity.php?l=57275718194040404040&a=0.5&am=3&m=THUNDER1~RAMASUNDAR0~SUBURB2~GTRACE3~CARINTERIOR4~CARINTERIOR5~THUNDER6~CAFE7~THUNDER8~THUNDER9&d=0",
				"Cafe"				: "https://mynoise.net/NoiseMachines/custom.php?l=47464739393032696831&m=RAIN41~RAIN42~CAFE2~CAFE3~RAIN44~CAFE4~RAIN45~RAIN47~CAFE7~CAFE8&d=0&title=Tin%20Roof%20Rain%20Cafe",
				"Spring Walk"		: "https://mynoise.net/NoiseMachines/springWalkSoundscapeGenerator.php?c=0&l=2626005657262626262600&d=0"
			},

			"Media": {
				"Netflix"			: "https://www.netflix.com/browse",
				"CrunchyRoll"		: "https://www.crunchyroll.com/",
				"Plex"				: "https://app.plex.tv/desktop",
				"Youtube"			: "https://youtube.com",
				"Twitch"			: "https://www.twitch.tv/",
				"TPB"				: "https://thepiratebay.org/",
				"Limetorrents"		: "https://limetorrent.cc/"
			},

			"Research" : {
				"Wikipedia"			: "https://en.wikipedia.org/wiki/Main_Page",
				"Liquipedia"		: "https://liquipedia.net/dota2/Main_Page",
				"DwarfFortress Wiki": "http://dwarffortresswiki.org/",
				"Project Gutenberg" : "https://www.gutenberg.org/",
				"Kahn Academy"		: "https://www.khanacademy.org/",
				"Bulbapedia"		: "https://bulbapedia.bulbagarden.net/wiki/Main_Page"
			},

			"Other": {
				"Trello"	: "https://trello.com/",
				"Calendar"			: "https://calendar.google.com/calendar/r",
				"Tesla"				: "https://www.tesla.com/teslaaccount",
				"Photos"			: "https://photos.google.com/",
				"Amazon"			: "https://smile.amazon.com"
			},

			"Development": {
				"OpenAi"			: "https://openai.com/blog/",
				"GitHub"			: "https://github.com/",
				"Stack Overflow"	: "https://stackoverflow.com/",
				"Focus Timer"		: "https://tomato-timer.com/"
			},

			"Fun": {
				"XKCD"				: "https://www.xkcd.com/",
				"SMBC"				: "https://www.smbc-comics.com/",
				"The Oatmeal"		: "https://www.theoatmeal.com/comics"
				"Mythic Spoiler"	: "http://www.mythicspoiler.com/",
				"EDHRec"			: "https://edhrec.com/",
			},

			"Financial":{
				"Mint"				: "https://mint.intuit.com/overview.event"
			}
		};

var search = "https://duckduckgo.com/";		// The search engine
var query  = "q";							// The query variable name for the search engine

var pivotmatch = 0;
var totallinks = 0;
var prevregexp = "";

// ---------- BUILD PAGE ----------
function matchLinks(regex = prevregexp) {
	totallinks = 0;
	pivotmatch = regex == prevregexp ? pivotmatch : 0;
	prevregexp = regex;
	pivotbuffer = pivotmatch;
	p = document.getElementById("links");
	while (p.firstChild) {
		p.removeChild(p.firstChild);
	}
	match = new RegExp(regex ? regex : ".", "i");
	gmatches = false; // kinda ugly, rethink
	for (i = 0; i < Object.keys(sites).length; i++) {
		matches = false;
		sn = Object.keys(sites)[i];
		section = document.createElement("div");
		section.id = sn;
		section.innerHTML = sn;
		section.className = "section";
		inner = document.createElement("div");
		for (l = 0; l < Object.keys(sites[sn]).length; l++) {
			ln = Object.keys(sites[sn])[l];
			if (match.test(ln)) {
				link = document.createElement("a");
				link.href = sites[sn][ln];
				link.innerHTML = ln;
				if (!pivotbuffer++ && regex != "") {
					link.className = "selected";
					document.getElementById("action").action = sites[sn][ln];
					document.getElementById("action").children[0].removeAttribute("name");
				}
				inner.appendChild(link);
				matches = true;
				gmatches = true;
				totallinks++;
			}
		}
		section.appendChild(inner);
		matches ? p.appendChild(section) : false;
	}
	if (!gmatches || regex == "") {
		document.getElementById("action").action = search;
		document.getElementById("action").children[0].name = query;
	}
	document.getElementById("main").style.height = document.getElementById("main").children[0].offsetHeight+"px";
}

document.onkeydown = function(e) {
	switch (e.keyCode) {
		case 38:
			pivotmatch = pivotmatch >= 0 ? 0 : pivotmatch + 1;
			matchLinks();
			break;
		case 40:
			pivotmatch = pivotmatch <= -totallinks + 1 ? -totallinks + 1 : pivotmatch - 1;
			matchLinks();
			break;
		default:
			break;
	}
	document.getElementById("action").children[0].focus();
}

document.getElementById("action").children[0].onkeypress = function(e) {
	if (e.key == "ArrowDown" || e.key == "ArrowUp") {
		return false;
	}
}

function displayClock() {
	now = new Date();
	clock = (now.getHours() < 10 ? "0"+now.getHours() : now.getHours())+":"
			+(now.getMinutes() < 10 ? "0"+now.getMinutes() : now.getMinutes())+":"
			+(now.getSeconds() < 10 ? "0"+now.getSeconds() : now.getSeconds());
	document.getElementById("clock").innerHTML = clock;
}

window.onload = matchLinks();
displayClock();
setInterval(displayClock, 1000);
