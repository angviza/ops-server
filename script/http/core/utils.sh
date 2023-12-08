#!/bin/bash

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/shell-logger.sh"
STARTTIME=$(date +"%Y-%m-%d %H:%M:%S")
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
function saveto() {
    echo -n "$1" >"$2"
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
function md5str() {
    echo $(echo -n "$data" | md5sum | cut -d' ' -f1)
}
function md5file() {
    echo $(md5sum $data_last | cut -d' ' -f1)
}

function ischanged() {
    #[[ $ischange ]] && echo "no change,reporting..." || echo "has changed,reporting..."
    local data="$1"
    local data_last="$2.last"
    if [ ! -f $data_last ]; then
        echo "first get, changed"
        saveto "$data" "$data_last"
        onChanged 1 "$data"
    else
        local curr=$(md5str $data)
        local last=$(md5file $data_last)
        if [ $curr != $last ]; then
            echo "has changed"
            saveto "$data" $data_last
            onChanged 1 "$data"
        else
            echo "no change"
            onChanged 0
        fi
    fi
}
