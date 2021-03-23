#/bin/bash

# 脚本执行必须传入一个参数，就是k8s主节点IP地址
master_ip=$1
if [ "$master_ip" == "" ]; then
  echo "Error: please set master ip." &
  exit 210
else
  echo "master ip is $master_ip"
fi

K8S_BASEURL=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
K8S_GPGKEY="https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg"
POD_NETWORD=10.244.0.0

# 执行配置k8s阿里云源
cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=${K8S_BASEURL}
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=${K8S_GPGKEY}
EOF

# 安装kubeadm、kubectl、kubelet
yum install -y kubectl-1.16.0-0 kubelet-1.16.0-0 kubeadm-1.16.0-0

# 启动kubelet服务
systemctl enable kubelet && systemctl start kubelet

# 安装初始化镜像，参数详解查看文档 https://kubernetes.io/zh/docs/reference/setup-tools/kubeadm/kubeadm-init/
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.16.0 --apiserver-advertise-address ${master_ip} --pod-network-cidr=${POD_NETWORD}/16 --token-ttl 0

# kubeadm init 执行完成之后需要执行的操作
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
