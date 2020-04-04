#!/usr/bin/env python3

welcome_text = '''	<-< solarizer_util >->
For automatically replacing colors in text data, 
to be used for creating custom themes. ~ Luc Kadletz, 2020
'''

import sys, argparse

# The color palette we want to map to
# The key is an idendifier for the color
# The value is the tuple of the color (r,g,b)
# Here, I have the solarized palette
colors_target = {
	'base03'	:(  0,  43,  54),
	'base02'	:(  7,  54,  66),
	'base01'	:( 88, 110, 117),
	'base00'	:(101, 123, 131),
	'base0'		:(131, 148, 150),
	'base1'		:(147, 161, 161),
	'base2'		:(238, 232, 213),
	'base3'		:(253, 246, 227),
	'yellow'	:(181, 137,   0),
	'orange'	:(203,  75,  22),
	'red'		:(220,  50,  47),
	'magenta'	:(211,  54, 130),
	'violet'	:(108, 113, 196),
	'blue'		:( 38, 139, 210),
	'cyan'		:( 42, 161, 152),
	'green'		:(133, 153,   0),
}

# The colors found in the target file
colors_found = []

# The regex used to find & replace colors
color_regex = '<r>,<g>,<b>'
# capture groups should be r g b, 
# TODO or h s v, or hex 

# A dictionary of colors_found to colors_target
color_mapping = {}

def main(argv):

	parser = argparse.ArgumentParser(description = welcome_text)
	parser.add_argument('--target', required=True)
	parser.add_argument('--mapping')
	parser.add_argument('--map-only', action='store_true')
	args = parser.parse_args()

	read_colors(args.target)
	# if mapping_file exists and not just_map
		# load it
	# else
		# generate map: colors_found colors_target
		# save map (force = just_map)

	# if not just_map
		# for each line of target_file
			# for each color regex matches
				# Find found_color in colors_found
				# Get target_color from color_mapping
				# replace found_color with target_color in line
		# save modified target_file as target_file-mapping_file

def read_colors(target: str) -> [(int,int,int)]:
	print(f"Getting colors from \"{target}\"")
	let colors = []
	# load target_file
	# for each line of target_file
		# for each color regex matches
			# add color to colors_found
	return colors


# Execute splash/main only if called directly
if __name__ == "__main__":
	main(sys.argv[1:])