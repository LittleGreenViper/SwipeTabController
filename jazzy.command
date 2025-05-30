#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"

echo "Creating Docs for the SwipeTabController Library\n"
rm -drf docs/*

jazzy  --readme ./README.md \
       --github_url https://github.com/LittleGreenViper/SwipeTabController \
       --title "SwipeTabController Doumentation" \
       --min_acl public \
       --theme fullwidth \
       --build-tool-arguments -scheme,"SwipeTabController",-target,"SwipeTabController"
cp ./icon.png docs/
cp ./img/* docs/img
