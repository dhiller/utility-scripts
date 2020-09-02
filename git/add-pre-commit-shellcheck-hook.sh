#!/bin/bash

# Create a pre-commit hook to execute shellcheck prior to committing

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd)

$SCRIPT_DIR/_add-hook.sh pre-commit pre-commit-shellcheck.sh ' || exit'
