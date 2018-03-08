#!/bin/bash

NEW_PATH=""
for dir in $(find $(pwd) -type d -not -path '*/.git/*' -and -not -path '.git/*' -print);
do 
  NEW_PATH="$NEW_PATH:$dir" 
done
echo $NEW_PATH
