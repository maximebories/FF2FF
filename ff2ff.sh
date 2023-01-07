# Copyright (C) 2023 Maxime Bories
#
# This file is part of FF2FF.
#
# FF2FF is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# FF2FF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FF2FF.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash

# Set default values for variables
directory="."
output_file="fonts.css"
exclude=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
	-d | --directory)
		directory="$2"
		shift # past argument
		shift # past value
		;;
	-o | --output)
		output_file="$2"
		shift # past argument
		shift # past value
		;;
	-e | --exclude)
		exclude="$2"
		shift # past argument
		shift # past value
		;;
	esac
done

# Function to parse font style from filename
parse_style() {
	local font_name=$1
	shopt -s nocasematch
	if [[ $font_name =~ .italic. ]]; then
		echo "italic"
	elif [[ $font_name =~ .oblique. ]]; then
		echo "oblique"
	else
		echo "normal"
	fi
	shopt -u nocasematch
}

# Parse font weight from filename
parse_weight() {
	filename=$1
	shopt -s nocasematch
	# Check for weight adjectives in filename
	if [[ $filename =~ .Thin. ]]; then
		echo "100"
	elif [[ $filename =~ .(Extra-light|Ultra-light). ]]; then
		echo "200"
	elif [[ $filename =~ .Light. ]]; then
		echo "300"
	elif [[ $filename =~ .(Normal|Regular). ]]; then
		echo "400"
	elif [[ $filename =~ .(Medium|Semi-bold|Demi-bold). ]]; then
		echo "500"
	elif [[ $filename =~ .Bold. ]]; then
		echo "700"
	elif [[ $filename =~ .(Extra-bold|Ultra-bold). ]]; then
		echo "800"
	elif [[ $filename =~ .(Black|Heavy). ]]; then
		echo "900"
	else
		echo "400"
	fi
	shopt -u nocasematch
}

# Create here string to store @font-face declarations
declarations=$(

	# Generate @font-face declarations for each font file
	for font_file in $(find $directory -type f -name "*.[otw]tf" -or -name "*.woff2" -or -name "*.eot" -or -name "*.svg" ! -path "$exclude/*"); do
		font_family=$(basename $font_file | sed 's/\.[^.]*$//')
		font_style=$(parse_style $font_file)
		font_weight=$(parse_weight $font_file)
		# Generate @font-face declaration and append to here string
		echo "@font-face { font-family: '$font_family'; font-style: $font_style; font-weight: $font_weight; src: url('$font_file'); }"
	done

)

# Sort @font-face declarations alphabetically by font family name
echo "$declarations" | sort -t "'" -k 2 >$output_file

echo "Successfully generated $output_file"
