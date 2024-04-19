#!/bin/bash
# Change committer date of all commits to be same as author date
#
git filter-branch -f --env-filter \
    'export GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE'
