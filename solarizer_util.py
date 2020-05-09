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
		if(count != 0):
			print(f"replaced {count} colors...")
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
		print(f"{color_str} --> {replaced}")
		return replaced


### FUNCTIONS ###

def color_from_hex(hex_str: str) -> Color:
	r = int(hex_str[1:3], 16)
	g = int(hex_str[3:5], 16)
	b = int(hex_str[5:7], 16)
	return (r,g,b)

def hex_from_color(color: Color) -> str:
	return '#%02x%02x%02x' % color

def read_colors(target_file: str) -> ColorSet:
	print(f"Getting colors from \"{target_file}\"")
	colors = set()
	with open(target_file, "r") as target:
		for line in target:
			colors.update(find_colors(line))
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
	# TODO Do some fancy k-clustering algo here
	print(f"Generating color map for {len(found_colors)} colors")
	map_ = dict()
	for color in target_colors:
		map_[color] = list()
	map_["unlabeled"] = sorted(found_colors, key=lambda x : x[0]+x[1]+x[2])
	return map_

def save_mapping(path: str, color_map: ColorMap):
	print(f"Saving color mapping to \"{path}\"")
	with open(path, 'w') as mapping_file:
		mapping_file.write(json.dumps(color_map))

def load_mapping(path: str) -> ColorSet:
	mapping = ColorSet
	with open(path, 'r') as mapping_file:
		mapping = json.load(mapping_file)
		print(f"Loaded color map from \"{path}\": {json.dumps(mapping)}")
	return mapping

def replace_colors(target_file: str, replaced_file: str, color_map: ColorMap):
	print(f"Replacing colors in \"{target_file}\"")
	replacer = ColorStringReplacer(color_map, SOLARIZED, COLOR_HEX_REGEX)

	replaced = open(replaced_file,"w")
	with open(target_file,"r") as target:
		for line in target:
			replaced_line = replacer.replace_color_line(line)
			replaced.write(replaced_line)

	replaced.close()

	print(f"Colors have been replaced in {replaced_file}.")


### WORKFLOW ###

def main(argv):
	# Argument parsing
	parser = argparse.ArgumentParser(description = welcome_text)
	parser.add_argument('--target', required=True)
	parser.add_argument('--mapping')
	args = parser.parse_args()
	# Either generate a map file or load one and apply
	if(args.mapping):
		mapping = load_mapping(args.mapping)
		replace_colors(args.target, f"replaced_{args.target}", mapping)
	else:
		colors_found = read_colors(args.target)
		mapping = map_colors(colors_found, SOLARIZED)
		save_mapping(f"colors_{args.target}.json", mapping)


# Execute main only if called directly
if __name__ == "__main__":
	main(sys.argv[1:])