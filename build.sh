#!/bin/bash

CMD="$1"

if [[ -z "${CMD}" ]]; then
    export CMD="default"
fi

autoreconf
if [[ "${CMD}" == "default" || "${CMD}" == "all" ]]; then
    ./configure --enable-sanitize --disable-lto --enable-packetver=20150000 --enable-debug=gdb
    make -j3
    make install
    cd src/evol
    ./build.sh
elif [[ "${CMD}" == "old" ]]; then
    ./configure --disable-lto --enable-packetver=20150000 --enable-debug=gdb
    make -j3
    make install
    cd src/evol
    ./build.sh old
elif [[ "${CMD}" == "server" ]]; then
    ./configure --enable-sanitize --disable-lto --enable-packetver=20150000 --enable-debug=gdb
    make -j3
    make install
elif [[ "${CMD}" == "static" ]]; then
    ./configure LIBS="-lmysqlclient -lssl -lcrypto -pthread -lm -lz" --disable-64bit --enable-static --disable-lto --enable-packetver=20150000 --enable-debug=gdb
    make -j3
elif [[ "${CMD}" == "static64" ]]; then
    ./configure --enable-static --disable-lto --enable-packetver=20150000 --enable-debug=gdb
    make -j3
fi
exit $?
