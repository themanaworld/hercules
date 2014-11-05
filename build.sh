#!/bin/bash

autoreconf
./configure --enable-sanitize --disable-lto --enable-packetver=20150000 --enable-debug=gdb
make -j3
