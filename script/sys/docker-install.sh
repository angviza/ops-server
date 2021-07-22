yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum install -y containerd.io
yum install -y docker-ce docker-ce-cli 


cat >> /etc/docker/daemon.json <<EOF
{
"registry-mirrors":["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn","https://3laho3y3.mirror.aliyuncs.com","https://docker.mirrors.ustc.edu.cn"] 
}
EOF

systemctl enable docker
systemctl start docker



