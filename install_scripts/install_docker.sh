#/bin/bash
# 使用root用户安装docker

DOCKER_VERSION=docker-ce-18.09.9-3.el7
DOCKER_REGISTRY=https://registry.docker-cn.com
YUN_REPO=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo

# 卸载原有的 docker
yum remove docker \
docker-ce \
docker-client \
docker-client-latest \
docker-common \
docker-latest \
docker-latest-logrotate \
docker-logrotate \
docker-engine

# 清理残留目录
rm -rf /var/lib/docker
rm -rf /var/run/docker

# 添加阿里yum源，并更新yum索引
yum install -y yum-utils
yum-config-manager --add-repo ${YUN_REPO}
yum makecache fast

# 安装docker-ce,可以自定义版本
yum install -y ${DOCKER_VERSION}

# 设置为系统服务并启动docker
systemctl enable docker && systemctl start docker

# 设置镜像仓库源
cat <<EOF >/etc/docker/daemon.json
{
 "registry-mirrors": ["${DOCKER_REGISTRY}"],
 "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# 重启docker
systemctl daemon-reload
systemctl restart docker
