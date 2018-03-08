#!/bin/bash
for i in $(find . -type f -name "*.m4a" -print); do
    ffmpeg -i "$i" -ab 256k "${i%m4a}mp3"
done
