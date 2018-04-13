#!/bin/bash

function usage {
    local script_name=$(basename $0)
    cat <<EOF
Usage: $script_name [source_dir [output_file]]
       $script_name [-h|--help]

Creates a list of directories containing mp3 files from specified
source_dir into output_file. The list is sorted and unified.

Parameters:
    source_dir      = /Volumes/public/Musik
        The source directory to look for directories containing mp3
        files

    output_file      = $HOME/.mp3_dir_names_uniq.txt
        the file to write the list to

EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    usage
    exit 1
fi

IFS=$(echo -en "\n\b")

set -eu

source_dir=${1:-/Volumes/public/Musik}
if [ ! -d "$source_dir" ]; then
    echo "$source_dir is not a directory!"
    exit 1
fi

output_file=${2:-$HOME/.mp3_dir_names_uniq.txt}
if [ -f "$output_file" ]; then
    echo "Output file $output_file already exists!"
    exit 1
fi

temp_file=$(mktemp)

echo "Searching $source_dir for mp3 directories"
find "$source_dir" -type f -name "*.mp3" -print | sed -E 's/\/[^\/]+\.mp3$//' > $temp_file

echo "Sorting and unifying"
cat $temp_file | sort | uniq > $HOME/.mp3_dir_names_uniq.txt
