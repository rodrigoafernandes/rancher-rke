#!/usr/bin/env bash

yum install haproxy keepalived -y
setsebool -P haproxy_connect_any=1
cat > /etc/rsyslog.d/haproxy.conf <<EOF
ddUnixListenSocket /dev/log

:programname, startswith, "haproxy" {
  /var/log/haproxy.log
  stop
}
EOF
cat > /etc/haproxy/haproxy.cfg <<EOF
global
    log /dev/log local0
    user haproxy
    group haproxy
    daemon
    maxconn 256

defaults
    log global
    option dontlognull
    mode http
    retries 2
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout check           10s
    maxconn                 3000

frontend rke2-registration
    bind *:9345
    option tcplog
    mode tcp
    default_backend rke2-etcd

backend rke2-etcd
    mode tcp
    option tcp-check
    balance roundrobin
    server etcd0 192.168.56.70:9345 check
    server etcd1 192.168.56.71:9345 check

frontend kubernetes-api
    bind *:6443
    option tcplog
    mode tcp
    default_backend rke2-control-plane

backend rke2-control-plane
    mode tcp
    balance roundrobin
    option tcp-check
    server ctl0 192.168.56.60:6443 check
    server ctl1 192.168.56.61:6443 check

EOF
cat > /etc/keepalived/keepalived.conf <<EOF
vrrp_instance VRRP1 {
    state MASTER
    interface eth0
    virtual_router_id 11
    priority 200
    advert_int 1
    virtual_ipaddress {
        192.168.56.92
    }
}
EOF
haproxy -f /etc/haproxy/haproxy.cfg -c
keepalived -t
systemctl restart rsyslog
systemctl restart haproxy
systemctl start keepalived