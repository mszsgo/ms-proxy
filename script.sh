#!/usr/bin/env sh

# ******************************************************************************************************
# 服务构建与部署脚本

# 服务名
NAME="proxy"
VERSION="1.0.0"
IMAGE="registry.cn-hangzhou.aliyuncs.com/mszs/$NAME"

cd /drone/$NAME && pwd && ls -ltrh
docker info
# *** 构建镜像并推送到镜像仓库
docker build -t $IMAGE:latest ./
rm -rf /drone/$NAME
docker push $IMAGE:latest

# *** 部署服务
STACKGIT="https://github.com/mszsgo/ms-docker.git"
if [ ! -d "/drone/ms-docker/" ];then
  echo "新建 git clone $STACKGIT"
  cd /drone
  git clone $STACKGIT
fi
echo "更新 git pull $STACKGIT"
cd /drone/ms-docker && git pull $STACKGIT
echo "*** Stack deploy"
if [ $STACK_ENV ];then
  STACK_ENV="stack-vm"
fi
echo "*** Stack deploy STACK_ENV=$STACK_ENV"
docker stack deploy -c /drone/ms-docker/$STACK_ENV/micro-api-stack.yml micro

# *** 构建生产版本，发布生产前构建新版本镜像
docker tag $IMAGE:latest $IMAGE:$VERSION
docker push $IMAGE:$VERSION

echo "End ***************"

