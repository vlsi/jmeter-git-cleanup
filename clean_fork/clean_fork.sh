#!/bin/sh

# Rename trunk branch -> master
git branch -m trunk master

# Optional steps. Note: it is not clear which tags/branches are important in forks, so use with caution
# git for-each-ref --format='%(refname)' | grep '@' | xargs -n1 git update-ref -d
# Remove RC tags
# git for-each-ref --format='%(refname)' 'refs/tags/' | grep RC | xargs -n1 git update-ref -d
# Remove all tags/branches except master, v*
# git for-each-ref --format='%(refname)' | grep -v 'refs/tags/v' | grep -v master | xargs -n1 git update-ref -d

# See https://github.com/vlsi/bfg-repo-cleaner/releases

BFG="java -jar bfg-1.13.2-vlsi-master-44b5b85.jar"

$BFG --no-private --no-blob-protection '--blob-exec:command=./pngoptimizer,filemask=.png$,keepinput=false,cacheonly=true,minsizereduction=0' --strip-blobs-with-ids deleted-blob-ids.txt --delete-folders docs

# This is to revert "local" changes (e.g. replace local .png files with the ones after BFG)
git reset --hard

# Technically speaking, it is not important, however recompressing the repo
# helps for performance
# Note: the expired objects are removed forever, and it is expected you have
# a backup folder "before cleanup" just in case

git reflog expire --expire=now --all && git gc --prune=now --aggressive
