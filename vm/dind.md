docker run -d --privileged --name centos8 -p 2222:22 opmatrix/sshd-docker-builder

启动后要进入容器执行 
systemctl enable --now docker
否则重启后无法进入
yum install -y passwd