#!/bin/bash

function usage {
	echo "usage: $0 <directory> <file-extension>"
	echo "$1"
	exit 1
}


test -d "$1" || usage "'$1' is not a directory"
test "$2" != "" || usage "'$2' is an empty string"

(find "$1" -name "*.$2" -type f | sed -e 's/[^/]*$//' | sort | uniq) >> list_of_dirs.txt