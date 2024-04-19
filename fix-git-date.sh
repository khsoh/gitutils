#!/bin/bash
# Change author date and commit date of specific commit
#   fix-git-date <git commit hash> <new date>
# where <new date> is in RFC2822 format


if [[ $# -lt 2 ]]; then
    echo 'Usage:'
    echo '  ./fix-git-date.sh <git commit hash> <new date>'
    echo 'where <new date> is in RFC2822 format'
    exit 1
fi

git filter-branch -f --env-filter \
"if [[ \$GIT_COMMIT = $1 ]];
 then
   export GIT_AUTHOR_DATE=\"$2\"
   export GIT_COMMITTER_DATE=\"$2\"
fi
"

