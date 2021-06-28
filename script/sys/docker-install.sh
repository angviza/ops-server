yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y containerd.io
yum install -y docker-ce docker-ce-cli 


cat >> /etc/yum.repos.d/docker.repo <<EOF
{
"registry-mirrors":["http://hub-mirror.c.163.com","https://docker.mirrors.ustc.edu.cn","https://3laho3y3.mirror.aliyuncs.com","https://docker.mirrors.ustc.edu.cn"] 
}
EOF


systemctl start docker
systemctl enable docker


