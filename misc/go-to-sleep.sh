#!/bin/bash

set -euo pipefail
echo "systemctl hybrid-sleep" | sudo at now + 2 minutes
