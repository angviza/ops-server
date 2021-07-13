#!/bin/bash

moduel=$1     #模块（医废/维保）
prof=$2       #环境（开发/测试/正式）
org=$3        #组织（妇幼/昆华/福强）
timeSeconds=5 #时间，默认60
threadCount=1 #线程数，默认1

export JMETER_WORKSPACE=/data/workspace/jmeter/scripts/jmx
export JAVA_HOME=/data/services/commons/jdk/11.0.10
export JRE_HOME=$JAVA_HOME/jre
export JMETER_HOME=/data/services/jmeter/5.4.1

export CLSAAPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export CLASSPATH=$JMETER_HOME/lib/ext/ApacheJMeter_core.jar:$JMETER_HOME/lib/jorphan.jar:$CLASSPATH

export PATH=$JAVA_HOME/bin:$JMETER_HOME/bin:$PATH

#dirname=${datetime:0:8}
logpath=/data/static
datapath=/data/workspace/jmeter/scripts/jmx/waste/data

declare -A profiles=(
    ["dev"]="dev.idflc.cn"
    ["test"]="test.idflc.cn"
    ["pro"]="pro.idflc.cn"
)

rand() {
    min=$1
    max=$(($2 - $min + 1))
    num=$(date +%s%N)
    echo $(($num % $max + $min))
}
printstart() {
    echo -e "\n\033[1;36m┌───────start >─────[$moduel]────[$org]───[$prof]───────────────────┐\n"
    echo "start running $logdir ..."
}
printend() {
    echo -e "\n\033[1;36m└──────────[$moduel]────[$org]───[$prof]───────< end ────────────────┘\033[0m\n"
}
generate_post_data() {
    cat <<EOF
{
        "msgtype": "textcard",
        "textcard": {
                "title": "【$org】【$prof】【${moduel}_${op}】",
                "description": "<div class='gray'>192.168.1.9</div><div class='normal'>dev.idflc.cn</div><div class='highlight'>${ret}</div>",
                "url":"http://dev.idflc.cn/dev/9/8091/$logdir/",
                "btntxt": "更多"
        },
        "enable_id_trans": 0,
        "enable_duplicate_check": 0,
        "duplicate_check_interval": 1800
}
EOF
}

notification() {
    if [[ $ret == "200" ]]; then
        ret="成功"
    else
        ret="失败"
    fi
    curl -H "Content-Type: application/json" -H "token:test" -d "$(generate_post_data)" push.idflc.cn/wechat/push/cp001
}

#===
run() {
    scname=$1
    domain=${profiles[$prof]}
    datetime=$(date +%Y%m%d_%H%M%S)

    logdir="${moduel}_report_${org}_${prof}_${scname}_${datetime}"
    jtl=$logpath/$logdir/.jtl
    #${__P(domain,dev.idflc.cn)}
    #${__P(org,0)}

    jmeter.sh -JthreadCount=$threadCount -JtimeSeconds=$timeSeconds -Jdomain=$domain -Jdatapath=$datapath/$org/$prof -Jorg=$org -Jprof=$prof -n -t $JMETER_WORKSPACE/${moduel}/$scname.jmx -l $jtl -e -o $logpath/$logdir
    ret=$(sed -n '$p' $jtl | awk -F "," '{print $4}')
}

waste() {
    printstart
    # threadCount=$(rand 40 60)
    run sj
    threadCount=1
    notification
    run rk
    run ck

    find ${logpath} -mtime +3 -exec rm -rf {} \;
    printend
    echo ".........................................."
}
test() {
    echo $pr
    echo $dataname $dirname
}
case "$1" in
'waste')
    waste
    ;;
'test')
    test $2
    ;;
*)
    echo "Usage: $0 {waste|stop|restart|status|info|log} "
    exit 1
    ;;
esac
exit 0
