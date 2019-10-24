#!/bin/bash

# Create a prepare-commit-msg hook to add a signoff to commit message
# see https://stackoverflow.com/a/46536244/16193 

git status --porcelain
if [ $? -ne 0 ]; then
    echo "Dir $(pwd) is not a git directory!"
    exit 1
fi

if [ ! -d ".git" ]; then
    echo "You must be in the root directory of the git repository!"
    exit 1
fi

git_hook_filename=".git/hooks/prepare-commit-msg"
if [ -f "$git_hook_filename" ]; then
    echo "File $git_hook_filename already exists!"
    exit 1
fi

cat > "$git_hook_filename" <<EOF
#!/bin/sh

NAME=\$(git config user.name)
EMAIL=\$(git config user.email)

if [ -z "\$NAME" ]; then
    echo "empty git config user.name"
    exit 1
fi

if [ -z "\$EMAIL" ]; then
    echo "empty git config user.email"
    exit 1
fi

git interpret-trailers --if-exists doNothing --trailer \
    "Signed-off-by: \$NAME <\$EMAIL>" \
    --in-place "\$1"
EOF

chmod +x "$git_hook_filename"
