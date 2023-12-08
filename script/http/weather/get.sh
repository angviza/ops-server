#!/bin/bash
#================================================
#| load utils script
#================================================

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/../core/soaputil.sh"
#
#
dir_data=./data

REQUEST_getWeatherbyCityName="$dir_data/getWeatherbyCityName.xml"
REQUEST_thirdhip="$dir_data/getWeatherbyCityName.xml.last"

function onChanged() {
    if [ $1 != 0 ]; then #|| [ -n "$3" ]
        doReportdata
    fi
}

function doReportdata() {
    if [ "$postdata" = "$REQUEST_getWeatherbyCityName.tmp" ]; then
        echo "reporting..."
        reportdata
    fi
}

function getweather() {
    set_postdata "$REQUEST_getWeatherbyCityName" true
    updatepdx 7 "深圳"
    request_soap http://www.webxml.com.cn/WebServices/WeatherWebService.asmx
}

function reportdata() {
    set_postdata "$REQUEST_thirdhip"
    request_soap http://192.168.1.117:8080/logistics/carry/api/v1/third/hip
}

echo "+----------------- [ ${STARTTIME} ]----------------+"
getweather
echo -e "+------------------------ [END] ------------------------+\n"
