Apache JMeter git mirror cleanup
--------------------------------

This script removes irrelevant entries (e.g. `*.jar`) from Git mirror of Apache JMeter.

License
-------

Apache License 2.0


Usage
-----

    ./run.sh

It will clone Apache JMeter from https://github.com/apache/jmeter.git

To speedup the process you might populate `jmeter_clone` with a local clone of JMeter repository.
It will be used in `--reference jmeter_clone` automatically to speedup the clone.

Output is placed to `jmeter_git` folder.

Expected output
---------------

```
7,4M	target/jmeter_git/objects/pack
8,0K	target/jmeter_git/objects/info
7,4M	target/jmeter_git/objects
 28K	target/jmeter_git/info
 48K	target/jmeter_git/hooks
  0B	target/jmeter_git/refs/heads
  0B	target/jmeter_git/refs/tags
  0B	target/jmeter_git/refs/remotes/tags
  0B	target/jmeter_git/refs/remotes
  0B	target/jmeter_git/refs
  0B	target/jmeter_git/branches
7,6M	target/jmeter_git
```

Output can be seen at https://github.com/vlsi/jmeter-git-cleanup-result

It transfers 120 MiB (223958 objects) during clone, `.git` foder is 135MiB, total workspace size is 188MiB.

Known issues
------------

Release tags are placed on a side branches. The script remaps some of recent tags (since v2.3.1).

`master` branch should probably be named `master` not `trunk`.

`docs-x.y` branches look weird. This script does not try to fix that (yet).

javadocs are still located in `docs/api` folder. It should probably be removed.

Author
------

Vladimir Sitnikov <sitnikov.vladimir@gmail.com>
