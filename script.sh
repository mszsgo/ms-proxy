#!/usr/bin/env sh

# 服务构建与部署脚本

# 服务名
NAME="proxy"
VERSION="1.0.1"
IMAGE="registry.cn-hangzhou.aliyuncs.com/mszs/$NAME"

cd /drone/$NAME && pwd && ls -ltrh
docker info
# 构建镜像并推送到镜像仓库
docker build -t $IMAGE:latest ./
rm -rf /drone/$NAME
docker push $IMAGE:latest

# 部署服务
if [ ‐d /drone/ms-docker ];then
     echo "该目录，存在"
     cd /drone/ms-docker
     git pull https://github.com/mszsgo/ms-docker.git
else
     echo "没有该目录"
     cd /drone
     git clone https://github.com/mszsgo/ms-docker.git
fi
docker stack deploy -c /drone/ms-docker/stack-vm/micro-api-stack.yml micro

# 构建生产版本，发布生产前构建新版本镜像
docker tag $IMAGE:latest $IMAGE:VERSION
docker push $IMAGE:$VERSION
