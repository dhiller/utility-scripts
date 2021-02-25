#!/usr/bin/sh

echo 'Use env SHELLCHECK_PRE_COMMIT_HOOK_DISABLED to enable (1) or disable (0) this hook'

if [ ! -z "$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" ] && [ "$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" -eq 1 ]; then
    echo "Skipping shellcheck..."
    exit 0
fi

if ! command -V shellcheck; then
    echo "shellcheck was not found! See https://github.com/koalaman/shellcheck for more info!"
    exit 1
fi

result=0
shellcheck_log=$(mktemp)
for file in $(git diff --cached --name-only | grep -E '.sh$'); do
    if [ ! -f $file ]; then
        continue
    fi
    shellcheck -S warning $file >>$shellcheck_log
    if [ $? -ne 0 ]; then
        result=1
    fi
done
if [ $result -ne 0 ]; then
    echo "shellcheck failed!"
    cat $shellcheck_log
fi
exit $result
