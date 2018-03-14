#!/bin/bash

IFS=$(echo -en "\n\b")

temp_file=$(mktemp)

echo 'Finding mp3 directories'
find /Volumes/public/Musik -type f -name "*.mp3" -print | sed -E 's/\/[^\/]+\.mp3$//' > $temp_file

echo 'Sorting and unifying'
cat $temp_file | sort | uniq > mp3_dir_names_uniq.txt 
