#!/bin/bash

org="$1"
repo="$2"
auth="$3"

curl --fail -v -u "$auth" -X POST \
    "https://api.github.com/repos/$org/$repo/hooks" \
    -H 'Content-Type: text/json; charset=utf-8' \
    --data @- << EOF
{
  "name": "web",
  "active": true,
  "events": [
    "push",
    "pull_request",
    "delete",
    "create",
    "issue_comment",
    "member",
    "public",
    "repository"
  ],
  "config": {
    "url": "https://notify.travis-ci.org",
    "content_type": "form",
    "insecure_ssl": "0"
  }
}
EOF

