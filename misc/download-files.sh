#!/bin/bash

# Downloads a set of media db files from a rest api
# Parameters:
#    1: input file list
#    2: output file name (will be created in current working directory)

function usage {
    echo "Usage: $0 <username> <password> <input-file> <output-file>"
    exit 1
}

set -e

CWD=$(pwd)

if [ "$1" == "" ]; then
    usage
fi
username=$1

if [ "$2" == "" ]; then
    usage
fi
password=$2

if [ "$3" == "" ]; then
    usage
fi
REST_FILE_BASE_URL="$3"

if [ ! -f "$4" ]; then
    usage
fi

OUTPUT_FILE="$CWD/$4"
if [ -f "$OUTPUT_FILE" ]; then
    echo "File $OUTPUT_FILE already exists!"
    usage
fi

MISSING_FILES="$1"

# Do not let wget stop file download if file is missing
set +e
TEMP_DIR=$(mktemp -d)
for file in $(cat "$MISSING_FILES")
do
    echo "Downloading $file"
    wget --user=$username \
         --password=$password \
         -q \
         -O $TEMP_DIR/$file \
         $REST_FILE_BASE_URL/$file
done
echo "Downloaded files to $TEMP_DIR"

ERROR_LOG="$TEMP_DIR/errors.log"

echo "Empty files:" > "$ERROR_LOG"
find "$TEMP_DIR" -size 0b -print >> "$ERROR_LOG"

cd "$TEMP_DIR"
zip -r "$OUTPUT_FILE" .
cd "$CWD"
echo "Created file $OUTPUT_FILE"

rm -rf "$TEMP_DIR"
echo "Temporary folder $TEMP_DIR deleted"
