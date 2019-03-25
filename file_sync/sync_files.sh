#!/bin/bash
set -euo pipefail
set -o posix
IFS=$'\n\t'

function usage {
    local script_name=$(basename $0)
    cat <<EOF
Usage: $0 -i|--input-file <text-file-with-directories>
          -d|--target-directory <target-directory>
          [-e|--file-extension <file-extension>]
          [-n|--number-of-dirs <no-of-dirs>]
          [-f|--flatten]
       $0 -h|--help

Copies files from specified number of directories to target
directory.

Directories are randomly selected using \`text-file-with-directories\` as
input, where that file is expected to contain a list of directories.

*Flattening* means that instead of keeping the source directory structure each
file is copied directly into the destination folder.

Parameters:
    \`text-file-with-directories\`
        The file containing the list of directories that contain the source
        files

    \`target-directory\`
        the target directory where the source files should be copied
        to

    \`file-extension\` (optional, default:"mp3")
        The file extension that determines which file type will be copied

    \`no-of-dirs\` (optional, default:100)
        The number of directories to copy files from
EOF
	test "$1" != "" && echo "$1"; exit 1 || exit 0
}

# how to parse args: https://stackoverflow.com/a/14203146/16193
POSITIONAL=()
while [[ $# -gt 0 ]]
do
	key="$1"

	case "$key" in
		-h|--help)
		usage ""
		;;
	    -f|--flatten)
	    flatten="yes"
	    shift
	    ;;
		-d|--source-directory)
	    target_directory="$2"
	    shift
		shift
	    ;;
		-i|--input-file)
	    source_file="$2"
	    shift
		shift
	    ;;
		-e|--file-extension)
	    file_extension="$2"
	    shift
		shift
	    ;;
		-n|--number-of-dirs)
		no_of_dirs="$2"
		shift
		shift
	    ;;
	    *)
	    usage ""
	    ;;
	esac
done

set +u
no_of_dirs="${no_of_dirs:-100}"
test -z "$flatten" && flatten=""
test -f "$source_file" || usage "input file '$source_file' is not a file"
test -z "$file_extension" || file_extension="mp3"
test -d "$target_directory" || usage "target directory '$target_directory' is not a directory"
set -u

input_file=$(mktemp /tmp/source_mp3_dirs.XXXXXX)
trap "rm -f ${input_file}" SIGINT SIGTERM EXIT
set +e
( cat  "$source_file" | grep -v "Misc" | gshuf | head -n "$no_of_dirs" | sort ) > "$input_file"
set -e

vi "$input_file"

echo "Start process? [Y/n]"
read input
case "$input" in
    n|no)
        exit 0
        ;;
    *)
        break
        ;;
esac

echo "Copying files:"
while read -r directory;
do
    if [ ! -d "$directory" ]; then
        echo "$directory does not exist! Skipping..."
        continue
    fi
	target_dir="$( echo "$directory" | sed 's/^\(\/[^\/]*\)\{4\}\///g' | sed 's/\/$//g' | sed 's/\// - /g' )"
	target_dir="$target_directory/$target_dir"
	echo -e "\t$directory"
	if [[ -z "$flatten" ]]; then
		mkdir -p "$target_dir"
		rsync -q -av --include='*/' --include="*.$file_extension" --exclude='*' "$directory/" "$target_dir/"
    else
        for source_file in $(find "$directory" -iname "*.$file_extension" -type f);
        do
            destination_filename="${target_dir} - $(basename "$source_file")"
            rsync -q -av "$source_file" "$destination_filename"
        done
	fi
done < "$input_file"
