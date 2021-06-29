#!/bin/bash
# 基础环境安装
yum install -y epel-release
yum update
yum install -y yum-utils device-mapper-persistent-data lvm2