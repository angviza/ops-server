#!/bin/bash
#dpkg-reconfigure dash  //no

work_root=/data/dflc
prod=pro

work_app=$work_root/$prod
chmod +x $work_root/javas.sh
start() {
    $work_root/javas.sh run $work_app/$1
}

#start workflow
#start dev
#start iot-gateway

while true; do
    sleep 1000
done
