#!/bin/bash
#dpkg-reconfigure dash  //no

work_dir=/data/dflc
prod=pro

chmod +x $work_dir/run.sh

start() {
    docker exec java $work_dir/run.sh run $work_dir/$prod/$1
}

stop() {
    $work_dir/run.sh stop $work_dir/$prod/$1
}

log() {
    $work_dir/run.sh log $work_dir/$prod/$1
}

restart() {
    stop $1
    start $1
    log $1
}

if [ $2 == 'bk' ]; then
    $work_dir/run.sh backup $work_dir/$prod/$1
fi

if [ $2 == 'stop' ]; then
    stop $1
fi
if [ -z $1 ]; then
    echo "[error] run ./restart.sh {dev|iot-gateway|workflow|...}"
else
    restart $1
fi
