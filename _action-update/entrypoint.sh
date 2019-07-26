#!/bin/sh -l

set -eu
. /opt/venv/bin/activate

# Requires BOT_TOKEN, DATA_BRANCHNAME, GIT_EMAIL, GIT_NAME to be included by workflow
export GITHUB_API_TOKEN=$BOT_TOKEN

# Get latest copy of repository
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"
git clone --depth 1 --no-single-branch https://github.com/LLNL/llnl.github.io.git
cd llnl.github.io
REPO_ROOT=$(pwd)

# Checkout new branch
git checkout $DATA_BRANCHNAME || git checkout -b $DATA_BRANCHNAME
git merge --ff-only master

# Run MASTER script
cd $REPO_ROOT/_explore/scripts
./MASTER.sh

# Commit update
cd $REPO_ROOT
TODAY_STAMP=$(date "+%Y-%m-%d")
git add -A .
git commit -m "$TODAY_STAMP Data Update (via bot)"

# Push update
git push --set-upstream origin $DATA_BRANCHNAME