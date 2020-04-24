#!/usr/bin/env bash

set -e # error -> trap -> exit
function info() { echo -e "[\033[0;34m $@ \033[0m]"; } # blue: [ info message ]
function pass() { echo -e "[\033[0;32mPASS\033[0m] $@"; } # green: [PASS]
function fail() { FAIL="true"; echo -e "[\033[0;31mFAIL\033[0m] $@"; } # red: [FAIL]
trap 'LASTRES=$?; LAST=$BASH_COMMAND; if [[ LASTRES -ne 0 ]]; then fail "Command: \"$LAST\" exited with exit code: $LASTRES"; elif [ "$FAIL" == "true"  ]; then fail finished with error; else pass "finished";fi' EXIT
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )" # this source dir


if [ "$#" -ne 1 ]; then
    info "Missing folder name"
fi


info "Creating repos dir"
cd $SRCDIR
mkdir -p repos
cd repos

CODE_FOLDER=$1
GIT_FOLDER=$1.git

info "CODE FOLDER:" $CODE_FOLDER
info "GIT  FOLDER:" $GIT_FOLDER


info "Clean folders"
rm -rf $GIT_FOLDER
rm -rf $CODE_FOLDER

info "Copy files"
cp -r ../../$CODE_FOLDER/.git .
mkdir $GIT_FOLDER
mv .git $GIT_FOLDER


info "Cleaning repo in $GIT_FOLDER"
cd $GIT_FOLDER
bfg --delete-files del.txt
bfg --replace-text ../../passwords.txt

git reflog expire --expire=now --all
git gc --prune=now --aggressive

info "Remove last commit"
git reset --hard HEAD~1 # Remove last commit @ bug https://github.com/rtyley/bfg-repo-cleaner/issues/302

info "Creating repo from bare repo"
cd ..
git clone $GIT_FOLDER $CODE_FOLDER
cd $CODE_FOLDER

info "Check"
#git grep secret-phrase $(git rev-list --all) | cut -c1-40
#git grep old-email $(git rev-list --all) | cut -c1-40

info "Open Fork and VSCode"
code . # Open VSCode
