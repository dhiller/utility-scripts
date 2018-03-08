#!/bin/bash

for project_name in $(cat $SVN_PROJECTS);
do
    svn co $SVN_SERVER/svn/$project_name
done
