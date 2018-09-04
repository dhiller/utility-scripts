#!/bin/bash

function usage {
  echo "Usage: $0 <file-containing-diff-files>"
}

if [ ! -f $1 ]; then
  usage
  exit 1
fi

diff_files="$1"
# display files
should_exit=0
while [ $should_exit -ne 1 ]; do
  for diff_file in $(cat $diff_files); do
    should_exit=1
    echo "Display diff file $diff_file? [Y]es / [n]o / [r]estart / e[x]it"
    read input </dev/tty
    case $input in
      n)
        ;;
      r)
        should_exit=0
        break
        ;;
      x)
        exit 0
        ;;
      *)
        cat $diff_file | colordiff | less -r
        ;;
    esac
  done
done

