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
function after_response() {
    local now=$(now)
    if [ $code == 401 ] && [ $retrys -gt 0 ]; then
        retrys=$((retrys - 1))
        cache_getx "$cache_token"
        request
    else
        retrys=$max_retries
        RESULT="$res"
    fi
}
function onError() {
    err "gio 出错了$1  $RESULT"
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
    deviceId=${deviceId:-"440307004911870000010"}
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
    change $deviceId
    ;;
*)
    echo "cmd $1 not found"
    ;;
esac
