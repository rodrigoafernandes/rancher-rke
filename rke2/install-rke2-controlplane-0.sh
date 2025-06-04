#!/usr/bin/env bash

export INSTALL_RKE2_TYPE="server"
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server.service
cat > /etc/rancher/rke2/config.yaml <<EOF
server: https://192.168.56.92:9345
token: devsecops2025
node-ip: 192.168.56.60
disable-etcd: true
cni: calico
tls-san:
  - 192.168.56.92
node-taint:
  - "CriticalAddonsOnly=true:NoExecute"
disable:
  - rke2-ingress-nginx
  - rke2-metrics-server
EOF
systemctl start rke2-server.service