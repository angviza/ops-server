#!/bin/bash
apisix restart
nohup manager-api -p /usr/local/apisix/dashboard/ > out.log 2>&1 &