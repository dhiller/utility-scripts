#!/bin/bash

function usage {
    local script_name=$(basename $0)
    cat <<EOF
Usage: $script_name [no_of_dirs [target_dir [source_file]]]
       $script_name [-h|--help]

Copies mp3 files from specified number of directories to target
directory. Directories are randomly selected using source_dir_file.

Parameters:
    no_of_dirs      = 100
        The number of directories to copy files from

    target_dir      = /Volumes/PARACARD
        the target directory where the source files should be copied
        to

    source_dir_file = $HOME/.mp3_dir_names_uniq.txt
        the file containing the directories where the mp3 files reside
        
EOF
}

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    usage
    exit 1
fi

IFS=$(echo -en "\n\b")

set -eu

no_of_dirs="${1:-100}"

target_main_dir="${2:-/Volumes/PARACARD}"
if [ ! -d "$target_main_dir" ]; then
    echo "Target $target_main_dir does not exist!"
    usage
    exit 1
fi

source_file="${3:-$HOME/.mp3_dir_names_uniq.txt}"
if [ ! -f "$source_file" ]; then
    echo "$source_file does not exist!"
    usage
    exit 1
fi

input_file=$(mktemp /tmp/source_mp3_dirs.XXXXXX)

gshuf "$source_file" | head -"$no_of_dirs" > "$input_file"

vi "$input_file"

while read -r dir;
do
    target_dir="/Volumes/PARACARD/$(echo "${dir#/Volumes/public/Musik/}" | sed -E 's/\// - /g')"
    echo "Syncing $dir" to "$target_dir"
    rsync -av --progress --include='*/' --include='*.mp3' --exclude='*' "$dir/" "$target_dir"
done < "$input_file"
