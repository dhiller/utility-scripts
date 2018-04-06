#!/bin/bash

if [ ! -d "/opt/IDEA/$1" ]; then
        echo "Usage: $0 <idea-directory>"
        exit 1
fi

. ~/.wkd/auth

export JAVA_HOME="/usr/lib/jvm/jdk1.8.0_91"
export IDEA_VM_OPTIONS="/opt/IDEA/idea.vmoptions"

/opt/IDEA/$1/bin/idea.sh
