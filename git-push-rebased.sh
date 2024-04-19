#!/bin/bash

# Performs a safe push --force-with-lease of current branch AFTER an earlier git-safe-rebase.sh call

BRANCH=`git branch --show-current 2>/dev/null` || exit

# check for presence of ref
if ! git show-ref --exists refs/pre-rebase-$BRANCH 2>/dev/null ; then
  echo ref "refs/pre-rebase-$BRANCH" not present
  echo git-safe-rebase.sh was not called for branch $BRANCH
  exit 1
fi

if git push --force-with-lease=$BRANCH:refs/pre-rebase-$BRANCH ; then
  # Successfully pushed the branch - so delete the ref
  git update-ref -d refs/pre-rebase-$BRANCH
fi
