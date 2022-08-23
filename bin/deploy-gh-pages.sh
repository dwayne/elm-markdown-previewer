#!/usr/bin/env bash

set -e

echo "[BUILD]"
./bin/build-gh-pages.sh

echo "[DEPLOY]"

deploy_branch=gh-pages
deploy_dir=.dist
root_dir=.build/elm-markdown-previewer

git worktree add $deploy_dir $deploy_branch

rm -rf $deploy_dir/*
cp -r $root_dir/* $deploy_dir

git -C $deploy_dir add .

current_branch="$(git branch --show-current)"
hash="$(git log -n 1 --format='%h' $current_branch)"
message="Site updated to commit $hash from the $current_branch branch"

if git -C $deploy_dir commit -m "$message"; then
  git -C $deploy_dir push -u origin HEAD
fi

git worktree remove --force $deploy_dir

echo "[DEPLOYED]"
