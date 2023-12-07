#!/bin/bash

request_xml_tmpl=request.xml
response_data=./data/res.xml
#
#
#
#
#
#
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/../core/http.sh"
source "$script_dir/../core/soaputil.sh"

request_xml="$request_xml_tmpl.tmp"
response_data_last="$response_data.last"
cp $request_xml_tmpl $request_xml

echo "+----------------- [ ${STARTTIME} ]----------------+"

#theCityName
update 7 "深圳"

# ------------------------end set query---------------------

postxml @$request_xml -o $response_data http://www.webxml.com.cn/WebServices/WeatherWebService.asmx
#curl -s -o ./data/res.xml -H "Content-Type: text/xml; charset=utf-8" -d @.request.xml -X POST http://www.webxml.com.cn/WebServices/WeatherWebService.asmx
# echo $RESULT
# echo $RESULT >./data/res.xml
curr=$(md5sum $response_data | cut -d' ' -f1)
last=$(md5sum $response_data_last | cut -d' ' -f1)

if [ "$curr" != "$last" ] || [ ! -n "$1" ]; then
    [[ "$curr" == "$last" ]] && echo "no change,reporting..." || echo "has changed,reporting..."
    #curl -o .res.json -H "Content-Type: text/xml; charset=utf-8" -d @data/res.xml -X POST http://39.108.78.230:13336/logistics/carry/api/v1/third/hip
    #echo "$(<.res.json)"
    mv $response_data $response_data_last
else
    echo "no change"
fi
echo -e "+------------------------ [END] ------------------------+\n"
