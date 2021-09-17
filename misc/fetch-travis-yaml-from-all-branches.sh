#!/usr/bin/env bash
# Goes through all branches that exist, checks them out, and copies a possibly existing
# `.travis.yml` config file into a temporary directory.
# Then greps over all those config files to show eventually existing `secure` entries
# that essentially are encrypted values.

set -euo pipefail
set -x

temp_dir=$(mktemp -d /tmp/travisyaml-XXXXXX)
echo "writing files into $temp_dir"

for branch in $(git branch -a | grep remote | grep -v HEAD | sed -E 's#^ +remotes/origin/##g'); do
    git checkout "$branch"
    [ -f ".travis.yml" ] && git annotate ".travis.yml" >"$temp_dir/travis-${branch/\//_}.yaml"
done

grep -B 3 'secure' $temp_dir/*.yaml >"$temp_dir/secrets.txt"

less "$temp_dir/secrets.txt"
