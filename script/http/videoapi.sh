#!/bin/bash
source ./http.sh
tokenf='./.token'
api="https://media.idflc.cn/api"

function token_set() {
    # echo "token_set $@"
    local token=$(check_token)
    echo "-H \"Access-Token:$token\" $@"
}

function gettoken() {
    res=$(curl -s "$api/user/login?username=dflc&password=07dce313fa66737b06419ae3249c11dd")
    local token=$(jsonk_str "$res" "accessToken")
    echo $token >$tokenf
    echo "$token"
}

function teleboot() {
    info "teleboot"
    get "$api/device/control/teleboot1/$1"
    info "结果：$RESULT"
}
function change() {
    info "change"
    post "$api/user/changePassword?oldPassword=fe6d1fed11fa60277fb6a2f73efb8be2&password=asdf"
    info "结果：$RESULT"
}

deviceId=$2
deviceId=${deviceId:-"44030700491187000001"}

case "$1" in
'teleboot')
    teleboot $deviceId
    ;;
'change')
    change $deviceId
    ;;
*)
    echo "cmd $1 not found"
    ;;
esac
