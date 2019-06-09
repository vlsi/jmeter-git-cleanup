#!/bin/sh

# Rename trunk branch -> master
git branch -m trunk master


# Optional steps. Note: it is not clear which tags/branches are important in forks, so use with caution
# git for-each-ref --format='%(refname)' | grep '@' | xargs -n1 git update-ref -d
# Remove RC tags
# git for-each-ref --format='%(refname)' 'refs/tags/' | grep RC | xargs -n1 git update-ref -d
# Remove all tags/branches except master, v*
# git for-each-ref --format='%(refname)' | grep -v 'refs/tags/v' | grep -v master | xargs -n1 git update-ref -d


# See https://github.com/rtyley/bfg-repo-cleaner/issues/112
# So strip-blobs should come first, so BFG adds "Former-commit-id" footer
# delete-folders causes BFG 1.13.0 to skip adding the footer

java -jar bfg-1.13.0.jar --strip-blobs-with-ids deleted-blob-ids.txt

java -jar bfg-1.13.0.jar --no-blob-protection --delete-folders docs

# Technically speaking, it is not important, however recompressing the repo
# helps for performance
# Note: the expired objects are removed forever, and it is expected you have
# a backup folder "before cleanup" just in case

git reflog expire --expire=now --all && git gc --prune=now --aggressive
