自动识别到的第7个开始，全部获取到作为最后第7个参数，参数获取改为
```sh
EXPORTLIMIT=`echo ${@:7}`
EXPORTLIMIT=$(echo ${@:1})
```