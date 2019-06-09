Apache JMeter git fork cleanup
--------------------------------

This script removes irrelevant entries (e.g. `*.jar`) from Git forks of Apache JMeter.

License
-------

Apache License 2.0


Cleanup of Apache JMeter fork repository
----------------------------------------

1. Copy `clean_fork.sh` and `deleted-blob-ids.txt` to your fork repository
1. Download BFG 1.13.0 ( https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar , sha512=e037be1dd52bd122a57fed18ebc4923238666e9985ad2d40174344a1ca45a05abd9a59f1c2ea743be49d094fd76a5794a0e3160a9d3be04a7986c3a444df4fa8)
1. Run `clean_fork.sh` (or execute the commands manually, the order of commands is very important)
1. Done
1. You might want to cleanup old tags/branches as well

Author
------

Vladimir Sitnikov <sitnikov.vladimir@gmail.com>
