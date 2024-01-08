#!bin/bash
#/usr/local/script/apisix-start.sh
#/usr/bin/apisix init && /usr/bin/apisix init_etcd && /usr/local/openresty/bin/openresty -p /usr/local/apisix -g 'daemon off;' #apisix
/usr/bin/openresty -g "daemon off;" #放最后一行