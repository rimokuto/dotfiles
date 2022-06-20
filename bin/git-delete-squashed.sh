#!/bin/bash

OPTION=d
if [ "$1" = 'D' ]; then
  OPTION=D
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)

git checkout -q $current_branch && \
  git for-each-ref refs/heads/ "--format=%(refname:short)" | \
  while read branch; do
    mergebase=$(git merge-base $current_branch $branch) && \
      [[ $(git cherry $current_branch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergebase -m _)) == "-"* ]] && \
      git branch -$OPTION $branch;
done
