#!/bin/bash

find_git_repos() {
  ignore_pattern="./3rdparty"
  if [ "$#" -gt 0 ]; then
    if [ $1 = "-a" ]; then
      ignore_pattern="*"
    fi
  fi
  local repos=`find . -name ".git" -type d | sed 's/\/.git//' | grep -v $ignore_pattern | sort`
  for repo in $repos; do
    echo $repo
  done
}

# forgit can handle most of your batch git requests. Just use it like plain git and it will perform the task for each subfolder
forgit() {
  find_git_repos | xargs -I{} sh -c "echo ========= {} =========; git -C {} $*;"
}

# forgit can handle most of your batch git requests. Just use it like plain git and it will perform the task for each subfolder
forgit_all() {
  find_git_repos -a | xargs -I{} sh -c "echo ========= {} =========; git -C {} $*;"
}

# use this function to set the upstream for all subfolders respecting the currently used branches
# parameters:
#  $1 remote_name
batch_git_set_upstream() {
  local repos=$(find_git_repos)
  while read -r repo; do
    cd $repo
    echo "----$repo----"
    branch=$(git status | head -n 1 | cut -d ' ' -f 3)
    echo "Branch: $branch"
    list=$(git remote -v | cut -f 1 | sort -u)
    [[ $list =~ $1 ]] && echo "Setting upstream to $1"; git branch --set-upstream-to=$1/${branch} || echo "Remote $1 does not exist. Skipping repository"
    cd -
  done <<< "$repos"
}

# create a bare repository that contains all repos from the subfolders
# parameters:
#  $1 the remote's name
#  $2 the remote's url
batch_git_create_bare_remote() {
  current_dir=$(pwd)
  local repos=$(find_git_repos)
  while read -r repo; do
    cd $repo
    local_repo=$(pwd)
    echo "----$repo-----"
    bare_repo=$2/$repo
    mkdir -p $bare_repo
    cd $bare_repo
    git init --bare
    cd $local_repo
    git remote add $1 $bare_repo
    branch=$(git status | head -n 1 | cut -d ' ' -f 3)
    git push $1 $branch

    echo "Pushed branch: $branch to bare repository $1"
    cd $current_dir
  done <<< "$repos"
}

# Change the remote url of a remote for all repositories in subfolders
# parameters:
#  $1 the remote's name
#  $2 the remote's base url
batch_git_set_remote_url() {
  local repos=$(find_git_repos)
  while read -r repo; do
    cd $repo
    local_repo=$(pwd)
    echo "----$repo-----"
    bare_repo=$2/$repo
    git remote set-url $1 $bare_repo
    branch=$(git status | head -n 1  | cut -d ' ' -f 3)
    cd -
  done <<< "$repos"
}

# adds a new remote to all git repos in subfolders
# parameters:
#  $1 the remote's name
#  $2 the remote's base url
batch_git_add_remote() {
  local repos=$(find_git_repos)
  while read -r repo; do
    cd $repo
    local_repo=$(pwd)
    echo "----$repo-----"
    bare_repo=$2/$repo
    git remote add $1 $bare_repo
    branch=$(git status | head -n 1 | cut -d ' ' -f 3)
    cd -
  done <<< "$repos"
}
