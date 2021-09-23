#!/bin/bash
result=0

# Collect git information
branch=${GITHUB_HEAD_REF}
base=${GITHUB_BASE_REF}
clone_link="https://github.com/$GITHUB_REPOSITORY.git"

# Clone repo
echo "Cloning $GITHUB_REPOSITORY"
git clone $clone_link repo
cd repo
git checkout $branch

# Collect changed files
git diff --name-only $branch $base >> changed.txt

# Collect tracked files
IFS="," read -a tracked_files <<< $INPUT_TRACKED_FILES

# Print any unchanged tracked files
echo ""; echo "Checking for changes in ${tracked_files[@]}..."; echo ""
for f in ${tracked_files[@]}; do
  modified_f=$(git diff --diff-filter=M --name-status $branch..$base | grep $f | wc -l)
  if (($modified_f != 1));
  then
    echo "$f file not found modified between branches"
    result=1
  fi
done

exit $result
