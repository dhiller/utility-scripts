#!/bin/bash

set -e

source_file="${1:-$HOME/mp3_dir_names_uniq.txt}"
no_of_dirs="${2:-100}"

IFS=$(echo -en "\n\b")

for dir in $(gshuf "$source_file" | head -"$no_of_dirs"); 
do
  TARGET_DIR="/Volumes/PARACARD/$(echo "${dir#/Volumes/public/Musik/}" | sed -E 's/\// - /g')"
  echo "Syncing $dir" to "$TARGET_DIR"
  rsync -av --progress --include='*/' --include='*.mp3' --exclude='*' "$dir/" "$TARGET_DIR"
done
