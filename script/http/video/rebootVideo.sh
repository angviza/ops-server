#!/bin/bash
source ./videoapi.sh
deviceId=$2
deviceId=${deviceId:-"44030700491187000001"}

echo ""
echo "=============================================="

case "$1" in
'teleboot')
    log "teleboot [$deviceId] "
    teleboot $deviceId
    ;;
*)
    echo "cmd $1 not found"
    ;;
esac
