#!/bin/sh

# prepare-commit-msg hook to add a signoff to commit message
# see https://stackoverflow.com/a/46536244/16193

NAME=$(git config user.name || exit 1)
EMAIL=$(git config user.email || exit 1)

git interpret-trailers --if-exists doNothing --trailer \
    "Signed-off-by: $NAME <$EMAIL>" \
    --in-place "$1"
