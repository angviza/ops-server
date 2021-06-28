#!/bin/bash
apis=(
    openapi.yml
    user.yml
    )

baseUrl=http://dev.idflc.cn/graphql/

printf -v apis_d "$baseUrl%s " "${apis[@]}"

nohup openapi-to-graphql $apis_d  -p 8085 > out.log 2>&1 &