#!/bin/bash
set -euo pipefail
set -o posix
IFS=$' \n\t'

function usage {
    local script_name=$(basename $0)
    cat <<EOF
Usage: $script_name -d|--source-directory <source-dir>
                    -f|--file-extension <file-extension>
                    [-r|--remove-output-file]
       $script_name -h|--help"

Writes a list of directories containing files matching selected file extension
from specified source-dir into output file \`list_of_<file-extension>s.txt\`. The
list is sorted and unified.

Parameters:
    source-dir
        The source directory to look for directories containing mp3
        files

    file-extension
        The file extension of the files that the directories need
        to contain

    remove-output-file
        Whether an existing output file should be deleted before
EOF
	test "$1" != "" && echo "$1"; exit 1 || exit 0
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
		shift
		shift
		;;
		-f|--file-extension)
		file_extension="$2"
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

set +u
test "$file_extension" != "" || usage "file-extension is an empty string"
test -d "$source_directory" || usage "source-directory '$source_directory' is not a directory"
set +e
output_file="list_of_${file_extension}s.txt"
test -z "$remove_output_file" || rm -f "$output_file" # touch "$output_file"
set -e
set -u

echo "Creating file list $output_file from $source_directory filtering for ${file_extension}s"

find "$source_directory" -name "*.$file_extension" -type f | sed -e 's/[^/]*$//' | sort | uniq | tee -a "$output_file"
