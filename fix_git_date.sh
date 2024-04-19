#!/bin/bash
# Change author date and commit date of specific commit

git filter-branch -f --env-filter \
'if [[ $GIT_COMMIT = '"$1"' ]];
 then
   export GIT_AUTHOR_DATE="'"$2"'"
   export GIT_COMMITTER_DATE="'"$2"'"
fi
'
