#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)

function usage() {
    cat <<EOF
usage: $0 name-of-hook target-script append-inside-call append-after-call

    create a symlink to a hook script that will be executed according to
    git hook rules. See
        git help hooks
    for details.

    requirements:
        - user must be in root of git directory
        - target (one of
                ls $SCRIPT_DIR/hooks/
          ) must exist
    
EOF
}

if [ $# -lt 4 ]; then
    usage
    exit 1
fi

if [ ! -d ".git" ]; then
    usage
    exit 1
fi

target_script=${SCRIPT_DIR}/hooks/$2
if [ ! -f $target_script ]; then
    usage
    echo "target not found, must be one of $(ls $SCRIPT_DIR/hooks)"
    exit 1
fi

append_inside_call=$3
append_after_call=$4

git status --porcelain
if [ $? -ne 0 ]; then
    usage
    echo "Dir $(pwd) is not a git directory!"
    exit 1
fi

if [ ! -d ".git" ]; then
    usage
    echo "You must be in the root directory of the git repository!"
    exit 1
fi

git_hook_filename="$(pwd)/.git/hooks/$1"
if [ ! -f "$git_hook_filename" ]; then
    touch ${git_hook_filename}
    chmod +x ${git_hook_filename}
fi

echo 'sh -c "'"${target_script}"' '"${append_inside_call}"'" '"${append_after_call}" >>${git_hook_filename}
