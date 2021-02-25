#!/usr/bin/sh

echo 'Use env SHFMT_PRE_COMMIT_HOOK_DISABLED to enable (1) or disable (0) this hook'

if [ ! -z "$SHFMT_PRE_COMMIT_HOOK_DISABLED" ] && [ "$SHFMT_PRE_COMMIT_HOOK_DISABLED" -eq 1 ]; then
    echo "Skipping shfmt..."
    exit 0
fi

if ! command -V shfmt; then
    echo "shfmt was not found! See https://github.com/mvdan/sh for more info!"
    exit 1
fi

result=0
shfmt_log=$(mktemp)
for file in $(git diff --cached --name-only | grep -E '.sh$'); do
    if [ ! -f $file ]; then
        continue
    fi
    shfmt -i 4 -d $file >>$shfmt_log
    if [ $? -ne 0 ]; then
        result=1
    fi
done
if [ $result -ne 0 ]; then
    echo "shfmt failed!"
    cat $shfmt_log
fi
exit $result
