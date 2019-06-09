Apache JMeter git fork cleanup
--------------------------------

This script removes irrelevant entries (e.g. `*.jar`) from Git forks of Apache JMeter.

License
-------

Apache License 2.0


Cleanup of Apache JMeter fork repository
----------------------------------------

1. Commit your local changes (just in case)
1. Copy `clean_fork.sh`, `deleted-blob-ids.txt`, and `blobExecCache` folder to your fork repository
1. Download BFG 1.13.2-vlsi ( https://github.com/vlsi/bfg-repo-cleaner/releases )
1. Run `clean_fork.sh` (or execute the commands manually)
1. Done
1. You might want to cleanup old tags/branches as well

Author
------

Vladimir Sitnikov <sitnikov.vladimir@gmail.com>
