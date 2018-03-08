#!/bin/bash

function help {
    echo "Usage: $0 <env> <file_to_encrypt> [<key_alias=alias/ml-config-key>]"
}

if [ "$#" -lt 2 ]; then
    help
    exit 1
fi

if [ "$1" == "--help" -o "$1" == "-h" ]; then
    help
    exit 0
fi

env="$1"; shift
content="$1"; shift
if [ ! -f "$content" ]; then
    help
    echo "File $content does not exist"
    exit 1
fi

key_id="${1:-alias/ml-config-key}"; shift

aws --profile "$env" kms encrypt \
    --key-id "$key_id" \
    --plaintext "fileb://${content}" \
    --output text \
    --query CiphertextBlob
