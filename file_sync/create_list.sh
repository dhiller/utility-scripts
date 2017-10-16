#!/bin/bash
set -euo pipefail
set -o posix
IFS=$' \n\t'

function usage {
	echo "usage: $0 -d|--source-directory <directory> -f|--file-extension <file-extension> [-r|--remove-output-file]"
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
		usage ""
		;;
		-d|--source-directory)
		source_directory="$2"
		test -d "$source_directory" || usage "source-directory '$source_directory' is not a directory"
		shift
		shift
		;;
		-f|--file-extension)
		file_extension="$2"
		test "$file_extension" != "" || usage "file-extension is an empty string"
		shift
		shift
		;;
		-r|--remove-output-file)
		remove_output_file="yes"
		shift
		;;
	    *)
		usage ""
	    ;;
	esac
done

output_file="list_of_${file_extension}s.txt"

set +u
test -z "$remove_output_file" || rm -f "$output_file" # touch "$output_file"
set -u

echo "Creating file list $output_file from $source_directory filtering for ${file_extension}s"

(find "$source_directory" -name "*.$file_extension" -type f | sed -e 's/[^/]*$//' | sort | uniq) >> "$output_file"
