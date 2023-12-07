#!/bin/bash
source ./utils.sh

max_retries=3
retrys=$max_retries

function before_request() {
    echo "$@"
}
function after_response() {
    local now=$(now)
    echo "end req : $now"
}
function request() {
    if [ $@ ]; then
        REQUESTBODY=$@
    fi
    local request_=$(before_request $REQUESTBODY)

    local prerequest="${request_//\&/\\\&}"
    info "request: $prerequest"
    local response=$(eval "curl -s -w "%{http_code}" $prerequest") #-v 查看请求响应主体
    local status=${response: -3}
    local res=${response::-3}
    local code=$(jsonk_int "$res" "code")
    if [ ! $code ]; then
        err "request error $response"
        RESULT="$status"
        onError $response
    else
        after_response $code $res
    fi

}
function post() {
    request -X POST $@
}

function postjson() {
    post -H "Content-Type: application/json" -d $@
}

function get() {
    request $@
}
