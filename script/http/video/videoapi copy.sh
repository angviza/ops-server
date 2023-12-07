tokenf='./.token'
api="https://media.idflc.cn/api"
now=$(date +"%Y-%m-%d %H:%M:%S")

log() {
    echo "$now : $1"
}
jsonk_str() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":\")[^\"]*")
}
jsonk_int() {
    echo $(echo $1 | grep -oP "(?<=\"$2\":)\s*\K-?\d+")
}
gettoken() {
    res=$(curl -s "$api/user/login?username=dflc&password=07dce313fa66737b06419ae3249c11dd")
    token=$(jsonk_str "$res" "accessToken")
    echo $token >$tokenf
    log "get token:$token"
}
request() {
    if [ ! $token ]; then
        if [ ! -f $tokenf ]; then
            gettoken
        else
            token=$(cat $tokenf)
        fi
    fi
    echo $(curl -s -H "Access-Token:$token" "$1")
}

teleboot() {
    res=$(request "$api/device/control/teleboot1/$1")
    code=$(jsonk_int "$res" "code")
    if [ $code == 401 ]; then
        gettoken
        control
    else
        echo "$res"
    fi
}
