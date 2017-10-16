#!/bin/bash
set -euo pipefail
set -o posix
IFS=$'\n\t'

function usage {
	echo "usage: $0 [-f|--flatten] -i|--input-file <text-file-with-directories> -e|--file-extension <file-extension> -d|--target-directory <target-directory>"
	echo "       $0 -h|--help"
	test "$1" != "" && echo "$1"
	exit 1
}

# how to parse args: https://stackoverflow.com/a/14203146/16193
POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-h|--help)
		usage "help"
		;;
	    -f|--flatten)
	    flatten="yes"
	    shift
	    ;;
		-d|--source-directory)
	    target_directory="$2"
	    shift
		shift
	    ;;
		-i|--input-file)
	    input_file="$2"
	    shift
		shift
	    ;;
		-e|--file-extension)
	    file_extension="$2"
	    shift
		shift
	    ;;
	    *)
	    usage ""
	    ;;
	esac
done

set +u
test -z "$flatten" && flatten=""
test -f "$input_file" || usage "input file '$input_file' is not a file"
test -z "$file_extension" && usage "file extension must not be empty"
test -d "$target_directory" || usage "target directory '$target_directory' is not a directory"
set -u

while read directory
do
	target_dir="${directory%/}"
	target_dir="$target_directory/${target_dir##*/}"
	if [ -z "$flatten" ]; then
		mkdir -p "$target_dir"
	fi
	echo "Base source: $directory"
	for source_file in $(find "$directory" -name "*.$file_extension" -type f);
	do
		echo "Source: $source_file"
		if [ -z "$flatten" ]; then
			echo "Target: $target_dir/$source_file"
			cp -n "$source_file" "${target_dir}/"
		else
			filename=$(basename "$source_file")
			destination_filename="${target_dir} ${source_dir//\//-} - $filename"
			echo "Target: $destination_filename"
			cp -n "$source_file" "$destination_filename"
		fi
	done
done < "$input_file"
