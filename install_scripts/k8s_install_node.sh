#/bin/bash

K8S_BASEURL=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
K8S_GPGKEY="https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg"

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
yum install -y kubelet-1.16.0-0 kubeadm-1.16.0-0

# 启动kubelet服务
systemctl enable kubelet && systemctl start kubelet

# 加入集群，如果这里不知道加入集群的命令，可以登录master节点，使用kubeadm token create --print-join-command 来获取
#kubeadm join 192.168.31.213:6443 --token 7172cu.ouhrkxvv1wj5gdfr --discovery-token-ca-cert-hash sha256:b3613871b6812b09351f7501517149e48562927efc3a2f7b70f7bff29bfc697c
