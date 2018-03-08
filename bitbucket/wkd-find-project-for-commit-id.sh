#!/bin/bash

set -e

CWD=$(pwd)

COMMIT_ID="$1"
PROJECT="$2"

PROJECTS_LIST_FILE="bitbucket_projects.txt"
BITBUCKET_API_URL="http://stash.wkd.wolterskluwer.de/rest/api/1.0"

if [ "$PROJECT" != "" ]; then
    echo "$BITBUCKET_API_URL/projects/$PROJECT" > "$PROJECTS_LIST_FILE"
else
    curl -s "$BITBUCKET_API_URL/projects" > "$PROJECTS_LIST_FILE.tmp" 
    grep -e "\"href\":\"[^\"]\+\"" -o "$PROJECTS_LIST_FILE.tmp" | sed s/^\"href\":\"// | sed s/\"$// > "$PROJECTS_LIST_FILE"
fi
for PROJECT_URL in $(cat "$PROJECTS_LIST_FILE"); do
    PROJECT_KEY=${PROJECT_URL##*/}
    echo "Project $PROJECT_KEY:"
    curl -s "$BITBUCKET_API_URL/projects/$PROJECT_KEY/repos" > "$PROJECT_KEY.txt"
    for REPO_URL in $(grep -e "http:[^\"]\+\.git" -o "$PROJECT_KEY.txt"); do
        REPO_KEY=$(echo ${REPO_URL##*/})
        REPO_KEY=$(echo ${REPO_KEY%.git})
        echo -e "\t$REPO_KEY: "
        RESPONSE=$(curl -u $user_auth --write-out %{http_code} --silent --output /dev/null "$BITBUCKET_API_URL/projects/$PROJECT_KEY/repos/$REPO_KEY/commits/$COMMIT_ID")
        if [ "$RESPONSE" -eq "200" ]; then
            echo -e "\t\tfound!"
        fi
    done
    rm -f "$PROJECT_KEY.txt"
done

rm -f "$PROJECTS_LIST_FILE"

cd "$CWD"
