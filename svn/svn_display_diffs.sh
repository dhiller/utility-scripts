#!/bin/bash

function usage {
	echo "Usage: $0 <file-containing-diff-files>"
}

function display_diff_files_numbered {
	if [ ! -f $1 ]; then
        	echo "File $1 not found!"
	        exit 1
	fi
	diff_files="$1"
        index=0
        echo "Files stored in $diff_files:"
        for diff_file in $(cat $diff_files); do
                ((index++))
                printf '%3s: %s' "$index" "$diff_file"
                echo
        done
}

if [ ! -f $1 ]; then
	usage
	exit 1
fi

diff_files="$1"
file_index_default=1
# display files
number_of_files=$(cat $diff_files | wc -l)
display_diff_files_numbered "$diff_files"

while true; do
	echo "Which diff file to display [$file_index_default] (e[x]it/[d]isplay file list)? "
	read input </dev/tty
	case $input in
		x)
			exit 0
			;;
		d)
			display_diff_files_numbered "$diff_files"
			;;
		*)
			if [ ! -z $input ] && [[ $input -lt 1 || $input -gt $number_of_files ]]; then
				echo "Line $input not found"
			else
				file_index=${input:-$file_index_default}
				if [ ! -z $input ]; then
					((file_index_default=file_index+1))
				fi
				diff_file=$(sed -n "$file_index p" $diff_files)
				cat $diff_file | colordiff | less -r
			fi
			if [ -z $input ]; then
				((file_index_default++))
			fi
			if [[ file_index_default -gt $number_of_files ]]; then
				file_index_default=1
			fi
			;;
	esac
done

