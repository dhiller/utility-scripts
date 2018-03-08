#!/bin/zsh

cwd=$(pwd); for dir in $(find . -type d -not -name '\.*' -maxdepth 1 -print); (current_dir="$cwd/${dir##./}"; echo "Updating $current_dir"; cd $current_dir; git pull --all;)
