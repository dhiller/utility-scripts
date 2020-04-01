#!/bin/bash

# Create a prepare-commit-msg hook to add a signoff to commit message
# see https://stackoverflow.com/a/46536244/16193 

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)

$SCRIPT_DIR/_add-hook.sh prepare-commit-msg prepare-commit-signoff.sh 
