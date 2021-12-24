---

---
## 安装ss
```sh
pip install https://github.com/shadowsocks/shadowsocks/archive/master.zip -U
```

## 安装privoxy
```sh
yum install privoxy -y
```
配置 /etc/privoxy/config
```
listen-address 127.0.0.1:8118 # 8118 是默认端口，不用改
forward-socks5t / 127.0.0.1:1080 . #转发到本地端口，注意最后有个点
```

```
systemctl enable privoxy
systemctl start privoxy
```
配置环境变量
```profile
PROXY_HOST=127.0.0.1:8118
export http_proxy=$PROXY_HOST
export https_proxy=$PROXY_HOST
export ftp_proxy=$PROXY_HOST
export all_proxy=$PROXY_HOST
export no_proxy=localhost,172.16.0.0/16,192.168.0.0/16.,127.0.0.1,10.10.0.0/16

export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export FTP_PROXY=$ftp_proxy
export ALL_PROXY=$all_proxy
export NO_PROXY=$no_proxy
```
测试: $ curl -I www.google.com