#!/bin/bash
#dpkg-reconfigure dash  //no

work_dir=/data/dflc
prod=pro

chmod +x $work_dir/run.sh
start() {
    $work_dir/run.sh run $work_dir/$prod/$1
}

#start workflow
#start dev
#start iot-gateway

while true; do
    sleep 1000
done
