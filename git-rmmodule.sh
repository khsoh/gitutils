#!/bin/bash

usage () {
  echo "git-rmmodule <submodule-name>"
  exit 1
}

[ -z $1 ] && usage
submodule="$1"

### Remove a submodule
## Validate that there is a submodule name specified


## Get the top-level directory of repo
gitTop=$( git rev-parse --show-toplevel 2> /dev/null )
[[ "" == "$gitTop" ]] && echo "$PWD is not a git repository" && exit 0

# Step 1: change directory to top level
pushd $gitTop > /dev/null

# Step 2: Validate existence of submodule
git submodule foreach --quiet 'echo $name' | grep "^$submodule\$"

if [ $? != 0 ]; then
  echo Cannot find submodule: $submodule
  popd
  exit 1
fi

# Step 3: get the submodule path
submodpath=$(git config -f .gitmodules --list | grep "^submodule\.${submodule}.path=" | sed -e 's/submodule\..*\.path=\(.*\)/\1/')

# Step 3: Deinitialize submodule
git submodule deinit -f "$submodpath"

# Step 4: Remove submodule git directory
rm -rf ".git/modules/$submodule"

# Step 5: Remove from .gitmodules
git config -f .gitmodules --remove-section submodule."$submodule"

# Step 6: Stage changes to .gitmodules
git add .gitmodules

# Step 7: Remove from git cache
git rm --cached "$submodpath"


echo "Completed removing submodule $submodule , commit and push changes"
popd > /dev/null
