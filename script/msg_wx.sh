#!/bin/sh




req_send_msg_url=push.idflc.cn/wechat/push/cp001

req_msg=$(curl -s -H "Content-Type: application/json" -H "token:test" -d @/data/scripts/data.json  $req_send_msg_url)

echo "触发报警发送动作，返回信息为：" $req_msg
