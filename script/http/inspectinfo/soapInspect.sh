#!/bin/bash

bus_dir=./inspectinfo
cd $bus_dir
cp request.xml .request.xml

now=$(date "+%Y-%m-%d %H:%M:%S")

echo "+----------------- [ ${now} ]----------------+"

function update() {
    echo "$1s/></$2/"
    sed -i "$1s/></>$2</" .request.xml
}

# starttime 开始时间，结束时间必填
update 37 "$(date '+%Y-%m-%d 00:00:00')"
# endtime
update 38 "$now"
# ZT 状态：0 新增  1 接单  2 完成
update 40
# xqlx 需求类型：01 A类  02 B类  03 C类 04 D类 05 E类
update 42
# yslx 运送类型：01 标本  02 文件  03 陪检 04 处方取药 05 中心药房取药  06 取药箱到中心药房取药 07 转床 08 推床边胸片机 09 换床单 10 送紧急会诊单  11 送紧急手术单 12 其他项目
update 44
# qsks 起始科室：感染二区护士站
update 46
# mbks 目标科室名称 ： 放射科 ， B超室
update 48
# ysr 运送人 ： 黄文轩
update 50
# ------------------------end set query---------------------

curl -o ./data/res.xml -H "Content-Type: text/xml; charset=utf-8" -d @.request.xml -X POST http://192.168.26.61:7802/HIP/HQGL/getInspInfo

curr=$(md5sum ./data/res.xml | cut -d' ' -f1)
last=$(md5sum ./data/last.xml | cut -d' ' -f1)

if [ "$curr" == "$last" ] || [ ! -n "$1" ]; then
    [[ "$curr" == "$last" ]] && echo "no change,reporting..." || echo "has changed,reporting..."
    curl -o .res.json -H "Content-Type: text/xml; charset=utf-8" -d @data/res.xml -X POST http://39.108.78.230:13336/logistics/carry/api/v1/third/hip
    echo "$(<.res.json)"
    mv data/res.xml data/last.xml
else
    echo "no change"
fi
echo -e "+------------------------ [END] ------------------------+\n"
