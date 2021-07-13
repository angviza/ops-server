#!/bin/bash
yum install -y epel-release git make gcc-c++ which wget yum-utils openresty-openssl111-devel unzip
yum install -y https://github.com/apache/apisix/releases/download/2.6/apisix-2.6-0.x86_64.rpm
yum install -y https://github.com/apache/apisix-dashboard/releases/download/v2.6/apisix-dashboard-2.6-0.x86_64.rpm