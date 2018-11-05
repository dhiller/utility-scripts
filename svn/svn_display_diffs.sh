#!/bin/bash

function usage {
	echo "Usage: $0 <file-containing-diff-files>"
}

if [ ! -f $1 ]; then
	usage
	exit 1
fi

diff_files="$1"
file_index_default=1
# display files
while true; do
	index=0
	number_of_files=$(cat $diff_files | wc -l)
	echo "Files stored in $diff_files:"
	for diff_file in $(cat $diff_files); do
		((index++))
		printf '%3s: %s' "$index" "$diff_file"
		echo
	done

	echo "Which diff file to display [$file_index_default] (e[x]it)? "
	read input </dev/tty
	case $input in
		x)
			exit 0
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

