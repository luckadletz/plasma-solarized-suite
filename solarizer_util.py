#!/usr/bin/env python3

welcome_text = '''	<-< solarizer_util >->
For automatically replacing colors in text data, 
to be used for creating custom themes. ~~Luc Kadletz, 2020
'''

import sys
import argparse
import re
import json
from typing import List, Dict, Tuple, Set


### CONSTANTS ###

# The colors we want to end up with
SOLARIZED = {
	'base03'	:(  0,  43,  54),
	'base02'	:(  7,  54,  66),
	'base01'	:( 88, 110, 117),
	'base00'	:(101, 123, 131),
	'base0'		:(131, 148, 150),
	'base1'		:(147, 161, 161),
	'base2'		:(238, 232, 213),
	'base3'		:(253, 246, 227),
	'yellow'	:(181, 137,   0),
	'orange'	:(203, 75,   22),
	'red'		:(220,  50,  47),
	'magenta'	:(211,  54, 130),
	'violet'	:(108, 113, 196),
	'blue'		:( 38, 139, 210),
	'cyan'		:( 42, 161, 152),
	'green'		:(133, 153,   0),
}

# The regex used to find & replace colors for HEX codes
COLOR_HEX_REGEX = r'\#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})'


### OBJECTS ###

Color = Tuple[int, int, int]
# (r, g, b)

ColorSet = List[Color]
# Should not have duplicates, but not enforced.

ColorMap = Dict[str, ColorSet]
# Name of color to replace with -> Colors to replace

NamedColorSet = Dict[str, Color]
# Name of color -> color values

class ColorStringReplacer:

	def __init__ (self, color_map: ColorMap, target_colors: NamedColorSet, color_regex: str):
		self._color_map = color_map
		self._target_colors = target_colors
		self._color_regex = color_regex

	def replace_color_line(self, line: str) -> str:
		replaced, count = re.subn(self._color_regex, self._replace_color_fn, line)
		return replaced

	def replace_color(self, color_str: str) -> str:
		# Get color object from str
		orig_color = color_from_hex(color_str)
		# Find color bucket in colorMap
		target_color_label = self._find_color_label(orig_color)
		if(target_color_label == "unlabeled"):
			print(f"Could not find label for {color_str}!")
			return color_str
		# Get corresponding color from target_colors
		replacement_color = self._target_colors[target_color_label]
		# Get color str from color object
		replacement_color_str = hex_from_color(replacement_color)
		print(f"{color_str} --> {replacement_color_str}")
		return replacement_color_str

	def _find_color_label(self, target: Color) -> str:
		target_color_label = None
		for label in self._target_colors:
			for color_arr in self._color_map[label]:
				color = (color_arr[0],color_arr[1],color_arr[2])
				if (target == color):
					return label
		return "unlabeled"

	def _replace_color_fn(self, color_match_obj):
		color_str = color_match_obj[0]
		replaced = self.replace_color(color_str)
		return replaced


### FUNCTIONS ###

def color_from_hex(hex_str: str) -> Color:
	r = int(hex_str[1:3], 16)
	g = int(hex_str[3:5], 16)
	b = int(hex_str[5:7], 16)
	return (r,g,b)

def hex_from_color(color: Color) -> str:
	return '#%02x%02x%02x' % color # OK WHY THOugh?

def read_colors(targets) -> ColorSet:
	colors = set()
	for target in targets:
		print(f"Getting colors from {target.name}:")
		file_colors = set()
		for line in target:
			file_colors.update(find_colors(line))
		print(file_colors)
		colors.update(file_colors)
	return list(colors)

def find_colors(line: str) -> ColorSet:
	matches = re.finditer(COLOR_HEX_REGEX, line)
	colors = set()
	# TODO reuse color_from_hex
	for match in matches:
		r = int(match[1],16)
		g = int(match[2],16)
		b = int(match[3],16)
		color = (r,g,b)
		colors.add(color)
	return list(colors)

def map_colors(found_colors: ColorSet, target_colors: NamedColorSet) -> ColorMap:
	print(f"Generating color map for {len(found_colors)} colors.")
	map_ = dict()
	for color in target_colors:
		map_[color] = list()
	# Default every color to the closest one
	for color in found_colors:
		label = guess_color(color, target_colors)
		map_[label].append(color)
	# Sort colors by distance to target color
	for color in map_:
		compare = target_colors[color]
		if(compare == None): continue
		map_[color] = sorted(map_[color], key = lambda x : color_dist(x, compare))
	return map_

def guess_color(color: Color, options: NamedColorSet):
	guess = "unlabeled"
	best_dist = (255 * 255 * 255) + 1
	for label in options:
		dist = color_dist(color, options[label])
		if (dist < best_dist):
			best_dist = dist
			guess = label
	return guess

def color_dist(a: Color, b: Color):
	# weighted euclidian dist
	# https://www.compuphase.com/cmetric.htm
	del_r = abs(a[0] - b[0])
	del_g = abs(a[1] - b[1])
	del_b = abs(a[2] - b[2])
	if(del_r > 128) : 
		return ( 3 * del_r * del_r 
		+ 4 * del_g * del_g 
		+ 2 * del_b * del_b ) 
	else:
		return ( 2 * del_r * del_r 
		+ 4 * del_g * del_g 
		+ 3 * del_b * del_b ) 

def save_mapping(path: str, color_map: ColorMap):
	print(f"Saving color mapping to {path}")
	with open(path, 'w') as mapping_file:
		mapping_file.write(json.dumps(color_map))

def load_mapping(map_file) -> ColorSet:
	mapping = json.load(map_file)
	print(f"Loaded color map from \"{map_file.name}\"")
	for color in mapping:
		# [num] color : [[values]]
		print(f"[{len(mapping[color])}]\t{color}\t:{mapping[color]}")
	return mapping

def replace_colors(targets, color_map: ColorMap):
	for target in targets:
		print(f"Replacing colors in {target.name}:")
		replacer = ColorStringReplacer(color_map, SOLARIZED, COLOR_HEX_REGEX)
		replaced = open(f"solarized-{target.name}","w")
		for line in target:
			replaced_line = replacer.replace_color_line(line)
			replaced.write(replaced_line)
		replaced.close()
		print(f"Colors have been replaced in {replaced.name}.\n")


### WORKFLOW ###

def main(argv):
	# Argument parsing
	parser = argparse.ArgumentParser(description = welcome_text)
	parser.add_argument('--target', type=argparse.FileType('r'), required=True, nargs='+')
	parser.add_argument('--mapping', type=argparse.FileType('r'))
	args = parser.parse_args()
	# Either generate a map file or load one and apply
	if(not args.mapping):
		colors_found = read_colors(args.target)
		mapping = map_colors(colors_found, SOLARIZED)
		# TODO Add --force...	:(
		save_mapping("solarizer_map.json", mapping)
	else:
		mapping = load_mapping(args.mapping)
		replace_colors(args.target, mapping)


# Execute main only if called directly
if __name__ == "__main__":
	main(sys.argv[1:])