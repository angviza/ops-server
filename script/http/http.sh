#!/bin/bash
source ./utils.sh

tokenf='./.token'
max_retries=3
retrys=$max_retries
function check_token() {
    if [ $1 ]; then
        token=$(gettoken)
    elif [ ! $token ]; then
        if [ ! -f $tokenf ]; then
            token=$(gettoken)
        else
            token=$(cat $tokenf)
        fi
    fi
    echo "$token"
}

function request() {
    local request_=$(token_set $@)
    warn "req: $request_"
    # req="curl -s -H \"Access-Token:$token\" $@"
    local prerequest="${request_//\&/\\\&}"
    local res=$(eval "curl -s $prerequest")
    local code=$(jsonk_int "$res" "code")
    if [ $code == 401 ] && [ $retrys -gt 0 ]; then
        retrys=$((retrys - 1))
        check_token 1
        request $@
    else
        retrys=$max_retries
        RESULT="$res"
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
