#!/usr/bin/env bash

export INSTALL_RKE2_TYPE="server"
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
cat > /etc/rancher/rke2/config.yaml <<EOF
tls-san:
  - 192.168.56.92
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
disable-apiserver: true
disable-controller-manager: true
disable-scheduler: true
token: devsecops2025
node-ip: 192.168.56.70
cni: calico
EOF
systemctl start rke2-server.service
cp /etc/rancher/rke2/rke2.yaml /home/rkeoci/rke2-kubeconfig
chown rkeoci:rkeoci /home/rkeoci/rke2-kubeconfig