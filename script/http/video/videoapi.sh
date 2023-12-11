#!/bin/bash
# 获取当前脚本所在目录
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/../core/http.sh"

api="https://media.idflc.cn/api"

cache_token="./caches/.token"

mkdir -p ${cache_token%/*}

function before_request() {
    local token=$(cache_get "$cache_token")
    echo "-H \"Access-Token:$token\" $@"
}
# function after_response() {
# local status=$1
# local res=$2
# local code=$(jsonk_int "$res" "code")
# if [ $code == 401 ] && [ $retrys -gt 0 ]; then
#     retrys_do
#     cache_getx "$cache_token"
#     request
# else
#     retrys_reset
#     RESULT="$res"
# fi
# }
function onError() {
    err "Request Error $1  $RESULT"
    local status=$1
    local res=$2
    local code=$(jsonk_int "$res" "code")
    if [ $code == 401 ] && [ $retrys -gt 0 ]; then
        retrys_do
        cache_getx "$cache_token"
        request
    fi
}
function getAndcache() {
    case "$1" in
    "$cache_token")
        res=$(curl -s "$api/user/login?username=dflc&password=07dce313fa66737b06419ae3249c11dd")
        local token=$(jsonk_str "$res" "accessToken")
        echo "$token"
        ;;
    'cache_token1')
        change $deviceId
        ;;
    *)
        echo "cmd $1 not found"
        ;;
    esac
}

function teleboot() {
    local deviceId=$1
    deviceId=${deviceId:-"44030700491187000010"}
    info "teleboot $deviceId"
    get "$api/device/control/reboot/$deviceId"
    info "结果：$RESULT"
}
function change() {
    info "change"
    post "$api/user/changePassword?oldPassword=fe6d1fed11fa60277fb6a2f73efb8be2&password=asdf"
    info "结果：$RESULT"
}

case "$1" in
'teleboot')
    teleboot $2
    ;;
'change')
    change
    ;;
*)
    echo "cmd $1 not found"
    ;;
esac
