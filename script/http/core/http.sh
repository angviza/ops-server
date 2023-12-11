#!/bin/bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/utils.sh"

max_retries=3
retrys=$max_retries

function retrys_do() {
    retrys=$((retrys - 1))
    return $retrys
}

function retrys_reset() {
    retrys=$max_retries
    return $retrys
}

function before_request() {
    echo "$@"
}

function after_response() {
    local now=$(now)
    # local status=$1
    local res=$2
    # local code=$(jsonk_int "$res" "code")
    #local code=$(jsonk_int "$res" "code")
    RESULT=$res
    echo "end req : $now"
}

function request() {
    local args=$@
    if [ "$args" ]; then
        REQUESTPARAMS="$args"
        REQUESTID=$(echo "$REQUESTPARAMS" | md5sum | cut -d' ' -f1)
    fi
    local request_=$(before_request $REQUESTPARAMS)

    local prerequest="${request_//\&/\\\&}"
    info "request: $prerequest"
    local response=$(eval "curl -s -w "%{http_code}" $prerequest") #-v 查看请求响应主体
    local status=${response: -3}
    local res=${response::-3}
    if [ $status != 200 ]; then
        err "request error [$status] $response"
        onError $status $res
    else
        RESULT=$res
        after_response $status $res
    fi

}
function post() {
    retrys_reset
    request -X POST $@
}
function postxml() {
    post -H '"Content-Type: text/xml; charset=utf-8"' -d $@
}
function postjson() {
    post -H '"Content-Type: application/json; charset=utf-8"' -d $@
}

function get() {
    retrys_reset
    request $@
}
function set_postdata() {
    retrys_reset
    postdata_="$1"
    postdata="$postdata_.tmp"
    if [ -n "$2" ]; then
        cp $1 $postdata
    fi
}
