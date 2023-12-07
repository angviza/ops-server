#!/bin/bash
now=$(date +"%Y-%m-%d %H:%M:%S")
source ./shell-logger.sh
LOGGER_LEVEL=0
LOGGER_ERROR_TRACE=0
LOGGER_STDERR_LEVEL=4
LOGGER_COLOR=always
RESULT=""

xenv() { set -a && source "$ENV" && shift && "$@"; }

function jsonk_str() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":\")[^\"]*")
}
function jsonk_int() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":)\s*\K-?\d+")
}
