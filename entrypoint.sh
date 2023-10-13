#!/bin/sh

# ROUTE RULES
ip rule add fwmark 666 lookup 666
ip route add local 0.0.0.0/0 dev lo table 666

# CREATE TABLE
iptables-nft -t mangle -N clash

# RETURN LOCAL AND LANS
iptables-nft -t mangle -A clash -d 0.0.0.0/8 -j RETURN
iptables-nft -t mangle -A clash -d 10.0.0.0/8 -j RETURN
iptables-nft -t mangle -A clash -d 127.0.0.0/8 -j RETURN
iptables-nft -t mangle -A clash -d 169.254.0.0/16 -j RETURN
iptables-nft -t mangle -A clash -d 172.16.0.0/12 -j RETURN
iptables-nft -t mangle -A clash -d 192.168.50.0/16 -j RETURN
iptables-nft -t mangle -A clash -d 192.168.9.0/16 -j RETURN

iptables-nft -t mangle -A clash -d 224.0.0.0/4 -j RETURN
iptables-nft -t mangle -A clash -d 240.0.0.0/4 -j RETURN

# FORWARD ALL
iptables-nft -t mangle -A clash -p udp -j TPROXY --on-port 7893 --tproxy-mark 666
iptables-nft -t mangle -A clash -p tcp -j TPROXY --on-port 7893 --tproxy-mark 666

# REDIRECT
iptables-nft -t mangle -A PREROUTING -j clash

/clash
