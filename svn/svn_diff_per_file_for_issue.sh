#!/bin/bash
set -euo pipefail 

function usage() {
  echo "Usage: ${0##*/} <commit-message-search-string> [<svn-options>...]"
}

if [ "$#" -lt 1 ] || [ "$1" == "" ]; then
  usage
  exit 1
fi

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/functions.sh

no_of_svn_updates_plus_one=$(svn status --show-updates | wc -l)
if [ $no_of_svn_updates_plus_one -gt 1 ]; then
  echo "WARNING: svn workspace may need to be updated!"
fi

# create files containing all the diffs for each file
rev_nos=$(svn_find_rev_nos_for_issue ${@:-.})
tmp_files_not_found=$(mktemp files_not_found.XXXXXX --tmpdir)
tmp_diff_files=$(mktemp files_diffed.XXXXXX --tmpdir)
echo -n "Creating diffs "
for file in $(svn_files_changed_for_issue ${@:-.}); do
  file_not_found=$file
  file=$(echo $file | sed 's/^\/\?//g')
  while [[ $file == */* ]] && [ ! -f $file ]; do
    file=$(echo $file | sed 's/^[^\/]\+\///g')
  done
  if [ ! -f $file ]; then
    echo "$file_not_found" >> $tmp_files_not_found
  else
    tmp_file=$(mktemp --suffix=.diff ${file//[\/\.]/_}.XXXXXXX --tmpdir)
    echo $tmp_file >> $tmp_diff_files
    echo -n "."
    for rev_no in $(echo $rev_nos); do
      # ignore error if file not found in changeset
      set +e
      svn diff -c $rev_no $(echo $file | sed 's/^\///g') >> $tmp_file
      set -e
    done
  fi
done
echo "Created file list in $tmp_diff_files"
if [ $(cat $tmp_files_not_found | wc -l) -ne 0 ]; then
  echo "Files not found in working directory:"
  cat $tmp_files_not_found
fi
[ -f $tmp_files_not_found ] && rm -f $tmp_files_not_found

# display files
should_exit=0
while [ $should_exit -ne 1 ]; do
  for diff_file in $(cat $tmp_diff_files); do
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

