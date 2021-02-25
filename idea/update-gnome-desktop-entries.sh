#!/usr/bin/env bash

function create_desktop_entry() {
    version=$1
    idea_base_path=$2
    if [ ! -d "$idea_base_path" ]; then
        echo "idea_base_path $idea_base_path does not exist or is not a directory!"
    fi
    desktop_entry_file="/usr/share/applications/jetbrains-idea-${version}.desktop"
    cat <<EOF >$desktop_entry_file
[Desktop Entry]
Version=1.0
Type=Application
Name=IDEA ${version} IntelliJ
Icon=${idea_base_path}/bin/idea.svg
Exec="${idea_base_path}/bin/idea.sh" %f
Comment=Capable and Ergonomic IDE for JVM
Categories=Development;IDE;IDEA;IntelliJ
Terminal=false
StartupWMClass=jetbrains-idea-previous
EOF
    echo "Created $desktop_entry_file for $idea_base_path"
}

function update_desktop_entries() {
    rm -f "/usr/share/applications/jetbrains-idea-*.desktop"
    while IFS= read -r -d '' idea_dir; do
        idea_version=$(jq -r '.version' $idea_dir/product-info.json)
        create_desktop_entry $idea_version $idea_dir
    done < <(find /opt -maxdepth 1 -name 'idea-IU-*' -type d -print0)
}

if ! command -V jq; then
    echo 'stedolan jq is required!'
    exit 1
fi

update_desktop_entries
