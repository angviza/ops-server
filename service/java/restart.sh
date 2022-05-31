#!/bin/bash
#dpkg-reconfigure dash  //no

work_root=/data/dflc
chmod +x $work_root/javas.sh

cmd() {
    work_dir="$(readlink -f $2)"
    docker exec java $work_root/javas.sh $1 $work_dir
}

restart() {
    cmd restart $1
    cmd log $1
}
if [ -z $1 ]; then
    echo "[error] run ./restart.sh {dev|iot-gateway|workflow|...}"
else
    if [ -z $2 ]; then
        restart $1
    else
        cmd $2 $1
    fi
fi
