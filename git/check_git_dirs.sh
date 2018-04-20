#!/bin/bash

CWD=$(pwd)

for git_dir in $(find $(pwd) -name ".git" -type d -print);
do
    cd "$(echo "${git_dir%.git}")"
    git_dir=$(pwd)

    has_remote=$(git remote -v | wc -l)
    has_uncommitted_changes=$(git status --porcelain | wc -l)

    if [ "$has_remote" -eq 0 ] || [ "$has_uncommitted_changes" -ne 0 ]; then
        echo
        echo "Checked $git_dir:"
        if [ "$has_remote" -eq 0 ]; then
            echo "- no remote set up"
        fi
        if [ "$has_uncommitted_changes" -ne 0 ]; then
            echo "uncommitted changes:"
            git status --porcelain
        fi
    fi
done

cd $CWD
