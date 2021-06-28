#!/bin/bash
key='s3:tmp:test'
value=$(redis-cli -h 172.18.110.109 -p 6380 SCARD ${key})
echo ${value}