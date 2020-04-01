#!/usr/bin/sh

if [ ! -z "$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" ] && [ "$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" -eq 1 ]; then
    echo "Skipping shellcheck..."
    exit 0
fi
result=0
shellcheck_log=$(mktemp)
for file in $(git diff --cached --name-only | grep -E '.sh$'); do
    shellcheck -S warning $file >> $shellcheck_log
    if [ $? -ne 0 ]; then
        result=1
    fi
done
if [ $result -ne 0 ]; then
    echo "shellcheck failed!"
    cat $shellcheck_log
fi
exit $result
