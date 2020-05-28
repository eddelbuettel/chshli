#!/bin/sh
wget http://us.archive.ubuntu.com/ubuntu/dists/eoan/Contents-amd64.gz
zgrep "usr/lib.*/lib.*\.so\." Contents-amd64.gz > libContents-amd64
gzip -9v libContents-amd64
