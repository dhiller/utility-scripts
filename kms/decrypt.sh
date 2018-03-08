#!/bin/bash

function help {
    echo "Usage: $0 <env> <file_to_decrypt>"
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
b64_content="$1"; shift
if [ ! -f "$b64_content" ]; then
    help
    echo "File $b64_content does not exist"
    exit 1
fi

enc=$(mktemp -t enc.XXXXXXXXXX)
dec_b64=$(mktemp -t dec_b64.XXXXXXXXXX)
trap "rm -f $enc $dec_b64" SIGINT SIGTERM EXIT

base64 --decode < "$b64_content" > "$enc"
aws --profile "$env" kms decrypt --ciphertext-blob "fileb://$enc" --output text --query Plaintext > "$dec_b64"
base64 --decode < "$dec_b64"
