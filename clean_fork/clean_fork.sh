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

BFG="java -jar bfg-v1.14.0-vlsi-8885d69.jar"


# There are two style.css file in the repository: testdata/.../style.css should be CRLF, and xdocs/.../style.css should be LF
# For now we just keep style.css "as is" (it is excluded from the first processing, and it is NOT included into the second one)

$BFG --no-private --no-blob-protection '--blob-exec:command=./pngoptimizer,filemask=.png$,keepinput=false,cacheonly=true,minsizereduction=20' \
  --filter-eol 'eol=lf,exclude=(style.css|halfbanner.htm|HTMLParserTestFile_2.html|(\\.(cmd|bat)))$' \
  --filter-eol 'eol=crlf,include=(halfbanner.htm|HTMLParserTestFile_2.html|(\\.(cmd|bat)))$' \
  --strip-blobs-with-ids deleted-blob-ids.txt --delete-folders docs

# This is to revert "local" changes (e.g. replace local .png files with the ones after BFG)
git reset --hard

# Technically speaking, it is not important, however recompressing the repo
# helps for performance
# Note: the expired objects are removed forever, and it is expected you have
# a backup folder "before cleanup" just in case

git reflog expire --expire=now --all && git gc --prune=now --aggressive
