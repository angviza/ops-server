#!/bin/bash
STARTTIME=$(date +"%Y-%m-%d %H:%M:%S")
source ./shell-logger.sh
LOGGER_LEVEL=0
LOGGER_ERROR_TRACE=0
LOGGER_STDERR_LEVEL=4
LOGGER_COLOR=always
RESULT=""
function xenv() { set -a && source "$ENV" && shift && "$@"; }

function cache_get() {
    local cache_key=$1
    local cache_val=$2
    if [ $cache_val ]; then
        echo "$cache_val" >$cache_key
    else
        if [ ! -f $cache_key ]; then
            cache_val=$(getAndcache "$cache_key")
            echo "$cache_val" >$cache_key
        else
            cache_val=$(cat $cache_key)
        fi
    fi
    echo "$cache_val"
}
function cache_getx() {
    mv $1 "$1.del"
    cache_get $@
}

function now() {
    echo $(date +"%Y-%m-%d %H:%M:%S")
}
function jsonk_str() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":\")[^\"]*")
}
function jsonk_int() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":)\s*\K-?\d+")
}
