---
---
# dokcer cmd

升级容器
```sh
docker-compose up --force-recreate --build -d 
```

```sh
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock spotify/docker-gc
```

快速删除 none 镜像
```sh
docker rmi $(docker images | grep none | awk '{print $3}')
```