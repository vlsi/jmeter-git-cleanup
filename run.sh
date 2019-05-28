#!/bin/sh

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
  # tags/test-bin has unrelated Git history and its own "Initial commit". We don't need that
  (cd target/jmeter_git; git update-ref -d refs/tags/test)
  (cd target/jmeter_git; git update-ref -d refs/tags/test-bin)
  (cd target/jmeter_git; git update-ref -d refs/tags/test1157668)
  (cd target/jmeter_git; git update-ref -d refs/tags/testhead)

  rm -rf target/jmeter_git/refs/tags
  touch target/remove_remote_tags
fi

if [ ! -f target/remove_at_refs ]; then
  echo Removing refs with @ in name
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' | grep '@' | xargs -n1 git update-ref -d)
  touch target/remove_at_refs
fi

#if [ ! -f target/remove_doc_branches ]; then
#  echo Removing refs with @ in name
#  (cd target/jmeter_git; git for-each-ref --format='%(refname)' | grep '/docs' | xargs -n1 git update-ref -d)
#  touch target/remove_doc_branches
#fi

if [ ! -f target/remove_jars ]; then
  if [ ! -d lib ]; then
    mkdir lib
  fi
  if [ ! -f lib/bfg.jar ]; then
    curl -o lib/bfg.jar https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar
  fi
  echo Removing jars and classes
  (cd target; java -jar ../lib/bfg.jar --delete-files '*.{class,jar}' jmeter_git)
  touch target/remove_jars
fi

if [ ! -f target/remove_docs ]; then
  echo Identifying blob ids in docs/ folder
  (cd target/jmeter_git; git rev-list --all --objects | grep -E '^\w+ docs' | cut -d" " -f1 > ../to-delete.txt)

  echo Removing docs folder
  # This removes docs/ folder from all revisions (including the current one)
  (cd target; java -jar ../lib/bfg.jar --no-blob-protection --delete-folders docs jmeter_git)

  echo Removing old images
  # Old repository contained "unoptimized png files", so it might make sense to remove files
  # that are not present in the up to date branches
  # So we get the list of ids from docs/ folder and remove those blobs, except the ones
  # that are still referenced by current tags/branches
  (cd target; java -jar ../lib/bfg.jar --strip-blobs-with-ids ./to-delete.txt jmeter_git)

  touch target/remove_docs
fi

(cd target/jmeter_git; git reflog expire --expire=now --all && git gc --prune=now --aggressive)

du -h target/jmeter_git

#./roundtrip.sh
