#!/bin/bash
path=$1 #run script path
env=$2  #.env path
check() {
    status=$($path/run.sh status $env)
    pid=$(echo $status | grep -P 'pid=\d+' -o)
    echo $pid
    if [ $pid ]; then
        echo "is running ($pid)"
    else
        echo "not running"
        run
    fi
}
run() {
    echo " run ..."
    $path/run.sh status $env
    echo " run ..."
}
cnt=0
while [ $cnt -le 5 ]; do
    check
    sleep 1m
    cnt=$(($cnt + 1))
done
# pid="${a##*$'\n'}" #last line
# pid=$(echo $c | cut -d'm' -f 2) #cut
# echo 'len:'${#pid}
