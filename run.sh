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

  git clone $reference --no-hardlinks --mirror https://github.com/apache/jmeter.git target/jmeter_git

  # Set 'origin' URL to avoid accidental push to the main repository
  (cd target/jmeter_git; git remote set-url origin https://github.com/vlsi/jmeter-git-cleanup-result.git)
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
  rm -rf target/jmeter_git/refs/tags
  touch target/remove_remote_tags
fi

if [ ! -f target/remove_at_refs ]; then
  echo Removing refs with @ in name
  (cd target/jmeter_git; git for-each-ref --format='%(refname)' | grep '@' | xargs -n1 git update-ref -d)
  touch target/remove_at_refs
fi

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

if [ -f ref_map.txt ]; then
  echo Updating tags
  (cd target/jmeter_git; cat ../../ref_map.txt | git update-ref --stdin)
else
  (cd target/jmeter_git; git for-each-ref --format='update %(refname) %(objectname)' 'refs/tags/' > ../../ref_map.txt)
fi

(cd target/jmeter_git; git reflog expire --expire=now --all && git gc --prune=now --aggressive)

du -h target/jmeter_git
