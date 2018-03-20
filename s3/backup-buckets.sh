#!/bin/bash

function usage {
    echo "Usage: $0 <aws_profile> <target_dir>"
}

function main {
    local env="$1"; shift
    local backup_dir="$1"; shift

    if [ -z "$env" ] || [ -z "$backup_dir" ]; then
        usage
        exit 1
    fi

    local bucket_names
    bucket_names=$(aws --profile "$env" s3api list-buckets | jq -r '.Buckets[].Name' | grep -v 'access-logging')

    for bucket_name in $bucket_names; do
        echo "Syncing $bucket_name"
        aws s3 sync "s3://$bucket_name/" "$backup_dir/$bucket_name/"
    done
}

main "$@"
