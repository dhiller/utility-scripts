#!/bin/bash

CWD=$(pwd)

for git_dir in $(find $(pwd) -name ".git" -type d -print);
do
    cd "$(echo "${git_dir%.git}")"
    echo "Checking $(pwd)"

    has_remote=$(git remote -v | wc -l)
    if [ "$has_remote" -eq 0 ]; then
        echo "- no remote set up"
    fi

    has_uncommitted_changes=$(git status --porcelain | wc -l)
    if [ "$has_uncommitted_changes" -ne 0 ]; then
        echo "- uncommitted changes:"
        git status --porcelain
    fi

    echo
done

cd $CWD
