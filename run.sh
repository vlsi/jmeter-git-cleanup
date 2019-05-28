#!/bin/bash

if [ ! -d target ]; then
  mkdir target
fi

if [ ! -d target/jmeter_git ]; then
  echo Cloning Apache JMeter

  if [ -d jmeter_clone ]; then
    export reference="--reference jmeter_clone"
    echo Will use local JMeter clone
  fi

  git clone $reference --dissociate --mirror https://github.com/apache/jmeter.git target/jmeter_git

  # Set 'origin' URL to avoid accidental push to the main repository
  (cd target/jmeter_git; git remote set-url origin https://github.com/vlsi/jmeter-git-cleanup-result.git)
  # Rename trunk -> master
  (cd target/jmeter_git; git branch -m trunk master)
fi

if [ ! -f target/remove_pull ]; then
  echo Removing refs/pull
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' 'refs/pull/' | xargs -n1 git update-ref -d)
  rm -rf target/jmeter_git/refs/pull
  touch target/remove_pull
fi

if [ ! -f target/remove_remote_tags ]; then
  echo Removing refs/remotes/tags
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' 'refs/remotes/tags/' | xargs -n1 git update-ref -d)
  echo Removing all tags except v..
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' | grep -v 'refs/tags/v' | grep -v 'master' | xargs -n1 git update-ref -d)

  rm -rf target/jmeter_git/refs/tags
  touch target/remove_remote_tags
fi

if [ ! -f target/remove_at_refs ]; then
  echo Removing refs with @ in name
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' | grep '@' | xargs -n1 git update-ref -d)
  touch target/remove_at_refs
fi

if [ ! -d lib ]; then
  mkdir lib
fi
if [ ! -f lib/bfg.jar ]; then
  curl -o lib/bfg.jar https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar
fi

if [ ! -f target/remove_docs ]; then
  echo Removing docs folder
  (cd target; java -jar ../lib/bfg.jar --no-blob-protection --delete-folders docs jmeter_git)
  touch target/remove_docs
fi

if [ ! -f target/remove_jars ]; then
  BINARY_LIKE="class|jar|png|gif|jtl|js|map|css|svg|odt|pdf|sxi"
  (cd target/jmeter_git; git rev-list --all --objects | grep -E "\.($BINARY_LIKE)\$" | cut -d" " -f1 > ../to-delete.txt)
  comm -23 <(sort target/to-delete.txt) <(sort keep_blobs)  > target/to-delete2.txt
  echo Removing $BINARY_LIKE which are not longer present in current branches/tags
  echo If a blob is present in current commit, then it is retained in all previous ones
  (cd target; java -jar ../lib/bfg.jar --strip-blobs-with-ids ./to-delete2.txt jmeter_git)
  touch target/remove_jars
fi

(cd target/jmeter_git; git reflog expire --expire=now --all && git gc --prune=now --aggressive)

du -h target/jmeter_git

#./roundtrip.sh
