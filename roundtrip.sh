#!/bin/bash

rm -rf target/jmeter-git-cleanup-result
cd target
(cd jmeter_git; git push origin --mirror)

git clone https://github.com/vlsi/jmeter-git-cleanup-result.git
