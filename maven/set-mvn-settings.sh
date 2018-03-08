#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 <short_id_for_mvn_settings>"
    exit 1
fi

if [ -e "~/.m2/settings.xml" ]; then
    if [ ! -h "~/.m2/settings.xml" ]; then
        echo "Maven settings.xml is not a symbolic link!"
        exit 1
    fi
fi

target_file="~/.m2/settings_$1.xml"
if [ ! -e "$target_file" ]; then
    echo "Settings file $target_file not found!"
    exit 1
fi

find ~/.m2/ -type f -iname 'settings_.*\.xml' -print
