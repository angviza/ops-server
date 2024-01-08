---
title:
name:
tag:
 - [""]
---

# openresty docker-centos
## 安装

只用openresty  功能，可直接启动，无需修改配置
```sh
docker-compose up -d

docker exec resty nginx -s reload
```

    │  docker-compose-etcd.yml    apisix 用
    │  docker-compose.yml		  resty 
    │  README.md				
    │
    ├─conf
    │  │  nginx.conf			 #nginx 配置
    │  │
    │  ├─conf.d                  #http通用配置目录
    │  │      cache.conf		 #缓存配置
    │  │      gzip.conf          #gzip配置
    │  │
    │  ├─http.d                  #http 配置 目录
    │  │  │  cache               #缓存策略
    │  │  │  cros                #跨域
    │  │  │  default.http        #样例http server，server_name 命名，如baidu.com.http
    │  │  │  http                #http 通用配置
    │  │  │  https               #https 通用配置
    │  │  │
    │  │  └─default              #http server配置，跟*.http名称一致，如baidu.com
    │  │          example.conf   #location 配置
    │  │          example.stream #http upstream 配置
    │  │          ssl.conf.d     #https 配置
    │  │
    │  └─tcp.d                   # tcp 配置目录
    │          resty-tcp.socks   # tcp server
    │          tcp-balancer.socks.bak
    │          test.socks
    │
    └─script                     #脚本文件
            apisix-install.sh    #apisix 安装
            apisix-start.sh      #apisix 启动
            entrypoint.sh        #dokcer 入口脚本


## APISIX 

### 插件安装

#### apisix [官方文档](https://github.com/apache/apisix/tree/master/docs/zh/latest)



```sh
#安装依赖 https://github.com/apache/apisix/blob/master/docs/en/latest/install-dependencies.md#centos-7

# 去除docker-compose.yml 中注释部分，创建容器
# 安装 apisix & [apisix-dashboard](https://github.com/apache/apisix-dashboard)
docker exec resty /usr/local/script/apisix-install.sh
# 启动 apisix & dashbord
docker exec resty /usr/local/script/apisix-start.sh
```