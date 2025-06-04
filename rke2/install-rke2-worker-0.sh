#!/usr/bin/env bash

export INSTALL_RKE2_TYPE="agent"
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/
cat > /etc/rancher/rke2/config.yaml <<EOF
server: https://192.168.56.92:9345
token: devsecops2025
tls-san:
  - 192.168.56.92
node-ip: 192.168.56.80
EOF
systemctl start rke2-agent.service