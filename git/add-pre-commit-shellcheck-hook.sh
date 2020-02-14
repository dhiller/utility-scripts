#!/bin/bash

# Create a pre-commit hook to execute shellcheck prior to committing 

git status --porcelain
if [ $? -ne 0 ]; then
    echo "Dir $(pwd) is not a git directory!"
    exit 1
fi

if [ ! -d ".git" ]; then
    echo "You must be in the root directory of the git repository!"
    exit 1
fi

git_hook_filename=".git/hooks/pre-commit"
if [ -f "$git_hook_filename" ]; then
    echo "File $git_hook_filename already exists!"
    exit 1
fi

cat > "$git_hook_filename" <<EOF
#!/usr/bin/sh

if [ ! -z "\$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" ] && [ "\$SHELLCHECK_PRE_COMMIT_HOOK_DISABLED" -eq 1 ]; then
    echo "Skipping shellcheck..."
    exit 0
fi
result=0
shellcheck_log=\$(mktemp)
for file in \$(git diff --cached --name-only | grep -E '.sh$'); do
    shellcheck -S warning \$file >> \$shellcheck_log
    if [[ \$? -ne 0 ]]; then
        result=1
    fi
done
if [[ \$result -ne 0 ]]; then
    echo "shellcheck failed!"
    cat \$shellcheck_log
fi
exit \$result
EOF

chmod +x "$git_hook_filename"
