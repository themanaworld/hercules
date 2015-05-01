#!/bin/bash

CMD="$1"

if [[ -z "${CMD}" ]]; then
    export CMD="default"
fi

if [ -x "/usr/bin/mariadb_config" ]; then
    export SQL=" --with-mysql=/usr/bin/mariadb_config"
elif [ -x "/usr/bin/mysql_config" ]; then
    export SQL=" --with-mysql=/usr/bin/mysql_config"
else
    export SQL=""
fi

export COMMON="--disable-lto --enable-packetver=20150000 --enable-debug=gdb${SQL}"

autoreconf
if [[ "${CMD}" == "default" || "${CMD}" == "all" ]]; then
    export CC=gcc-5
    ./configure --enable-manager=no --enable-sanitize=full ${COMMON}
    make -j9
    make install
    cd src/evol
    ./build.sh
elif [[ "${CMD}" == "old" ]]; then
    ./configure ${COMMON}
    make -j9
    make install
    cd src/evol
    ./build.sh old
elif [[ "${CMD}" == "valgrind" ]]; then
    ./configure --enable-manager=no ${COMMON}
    make -j9
    make install
    cd src/evol
    ./build.sh old
elif [[ "${CMD}" == "server" ]]; then
    ./configure --enable-sanitize ${COMMON}
    make -j9
    make install
elif [[ "${CMD}" == "static" ]]; then
    ./configure LIBS="-lmysqlclient -lssl -lcrypto -pthread -lm -lz" --disable-64bit --enable-static ${COMMON}
    make -j9
elif [[ "${CMD}" == "static64" ]]; then
    ./configure --enable-static ${COMMON}
    make -j9
fi
exit $?
