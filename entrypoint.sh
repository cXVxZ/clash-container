#!/bin/sh

# ROUTE RULES
ip rule add fwmark 666 lookup 666
ip route add local 0.0.0.0/0 dev lo table 666

# `clash` chain for using tproxy to redirect traffic to the clash listening port 7893
iptables -t mangle -N clash

# skip traffic to LAN or reserved address
# reference:
# https://en.wikipedia.org/wiki/List_of_assigned_/8_IPv4_address_blocks
# https://en.wikipedia.org/wiki/Private_network#IPv4
# IANA - Local Identification
iptables -t mangle -A clash -d 0.0.0.0/8 -j RETURN
# IANA - Loopback
iptables -t mangle -A clash -d 127.0.0.0/8 -j RETURN
# IANA - Private Use
iptables -t mangle -A clash -d 10.0.0.0/8 -j RETURN
iptables -t mangle -A clash -d 172.16.0.0/12 -j RETURN
iptables -t mangle -A clash -d 192.168.0.0/16 -j RETURN
# IPv4 Link-Local Addresses
iptables -t mangle -A clash -d 169.254.0.0/16 -j RETURN
# Multicast
iptables -t mangle -A clash -d 224.0.0.0/4 -j RETURN
# Future Use
iptables -t mangle -A clash -d 240.0.0.0/4 -j RETURN

# Forward all the other traffic to port 7893 and set tproxy mark
iptables -t mangle -A clash -p tcp -j TPROXY --on-port 7893 --tproxy-mark 666
iptables -t mangle -A clash -p udp -j TPROXY --on-port 7893 --tproxy-mark 666

# Append the `clash` chain to PREROUTING to enable it
iptables -t mangle -A PREROUTING -j clash


/clash
