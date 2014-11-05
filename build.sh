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

source src/evol/tools/vars.sh

export COMMON="--enable-packetver=20150000 --enable-debug=gdb${SQL} --enable-epoll"
export CORES=$(cat /proc/cpuinfo|grep processor|wc -l)

autoreconf
if [ "$?" != 0 ]; then
    exit 1
fi
if [[ "${CMD}" == "default" || "${CMD}" == "all" ]]; then
    export CC=gcc
    ./configure --enable-manager=no --enable-sanitize=full ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make install
    if [ "$?" != 0 ]; then
        exit 1
    fi
    cd src/evol
    if [ "$?" != 0 ]; then
        exit 1
    fi
    ./build.sh
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "old" ]]; then
    ./configure --disable-lto ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make install
    if [ "$?" != 0 ]; then
        exit 1
    fi
    cd src/evol
    if [ "$?" != 0 ]; then
        exit 1
    fi
    ./build.sh old
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "valgrind" ]]; then
    ./configure --enable-manager=no ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make install
    if [ "$?" != 0 ]; then
        exit 1
    fi
    cd src/evol
    if [ "$?" != 0 ]; then
        exit 1
    fi
    ./build.sh old
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "gprof" ]]; then
    ./configure --enable-manager=no --enable-profiler=gprof ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make install
    if [ "$?" != 0 ]; then
        exit 1
    fi
    cd src/evol
    if [ "$?" != 0 ]; then
        exit 1
    fi
    ./build.sh gprof
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "server" ]]; then
    ./configure --enable-sanitize ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make install
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "static" ]]; then
    ./configure LIBS="-lmysqlclient -lssl -lcrypto -pthread -lm -lz" --disable-64bit --enable-static ${COMMON}
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
elif [[ "${CMD}" == "static64" ]]; then
    ./configure --enable-static ${COMMON} CPPFLAGS="${VARS}"
    if [ "$?" != 0 ]; then
        exit 1
    fi
    make -j${CORES}
    if [ "$?" != 0 ]; then
        exit 1
    fi
fi
echo "OK"
