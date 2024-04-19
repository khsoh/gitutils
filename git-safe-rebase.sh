#!/bin/bash

# Performs a safe rebase and later a safe push --force-with-lease

if [[ $# -lt 1 ]]; then
    echo 'Usage:'
    echo '  ./git-safe-rebase.sh <upstream> [<branch>]'
    echo 'Replays the commits of the current branch (or <branch> if it is given)'
    echo '  onto <upstream>.  A local new ref named refs/pre-rebase-<branch> is saved first'
    echo '  before the rebase operation is executed'
    exit 1
fi
UPSTREAM=$1
## Test existence of upstream branch
if [[ ! $(git branch --list $UPSTREAM) ]]; then
  echo Branch $UPSTREAM does not exist
  exit 1
fi

if [[ $# -gt 1 ]]; then
  BRANCH=$2
else
  BRANCH=`git branch --show-current`
fi
if [[ ! $(git branch --list $BRANCH) ]]; then
  echo Branch $BRANCH does not exist
  exit 1
fi

git update-ref refs/pre-rebase-$BRANCH refs/remotes/origin/$BRANCH
if [[ $? -gt 0 ]]; then
  exit $?
fi

git rebase $UPSTREAM $BRANCH
if [[ $? -gt 0 ]]; then
  exit $?
fi

