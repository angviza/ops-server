
# Readme

 自动识别到的第7个开始，全部获取到作为最后第7个参数，参数获取改为

```sh
EXPORTLIMIT=`echo ${@:7}`
EXPORTLIMIT=$(echo ${@:1})
```

```sh
#substring
b=${a:12:5} #where 12 is the offset (zero-based) and 5 is the length

#If the underscores around the digits are the only ones in the input, you can strip off the prefix and suffix (respectively) in two steps:

tmp=${a#*_}   # remove prefix ending in "_"
b=${tmp%_*}   # remove suffix starting with "_"
```
