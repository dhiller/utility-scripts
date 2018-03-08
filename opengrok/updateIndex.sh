#!/bin/bash

set -e

CWD=$(pwd)

# Fetch and/or update all public bitbucket repositories

cd /opt/opengrok/src/

TMP_PROJECTS=$(mktemp)
curl "http://bitbucket.wkd.wolterskluwer.de/rest/api/1.0/projects" > $TMP_PROJECTS
for PROJECT_URL in $(grep -e "\"href\":\"[^\"]\+\"" -o $TMP_PROJECTS | sed s/^\"href\":\"// | sed s/\"$//); do
    PROJECT_KEY=${PROJECT_URL##*/}
    TMP_REPOSITORIES=$(mktemp)
    curl "http://bitbucket.wkd.wolterskluwer.de/rest/api/1.0/projects/$PROJECT_KEY/repos" > "$TMP_REPOSITORIES"
    for REPO_URL in $(grep -e "http:[^\"]\+\.git" -o "$TMP_REPOSITORIES"); do
        PROJECT_DIR=${REPO_URL##*/}
        PROJECT_DIR=${PROJECT_DIR%.git}
        if [ ! -d "$PROJECT_DIR" ]; then
            git clone "$REPO_URL"
        else
            cd "$PROJECT_DIR"
            set +e
            git fetch --all
            git pull
            set -e
            cd ..
        fi
    done
    rm -f "$TMP_REPOSITORIES"
done

rm -f $TMP_PROJECTS

#./updateSVNRepos.sh

# rebuild indices
JAVA_OPTS="-Xmx4G" /opt/opengrok/bin/OpenGrok index

# Reindexing only didn't update list of projects
#service tomcat restart

cd "$CWD"
