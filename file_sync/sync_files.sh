#!/bin/bash

function usage {
	echo "usage: $0 <text-file-with-directories> <file-extension> <target-directory>"
	echo "$1"
	exit 1
}

set -e

test -f "$1" || usage "'$1' is not a file"
test "$2" != "" || usage "'$2' is an empty string"
test -d "$3" || usage "'$3' is not a directory"

while read DIRECTORY
do
	TARGET_DIR="${DIRECTORY%/}"
	TARGET_DIR="$3/${TARGET_DIR##*/}"
	echo "Copying $2 from $DIRECTORY TO $TARGET_DIR"
	mkdir -p "$TARGET_DIR"
	find "$DIRECTORY" -name "*.$2" -type f -exec cp -n {} "${TARGET_DIR}/" \;
done < "$1"