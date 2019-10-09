#!/bin/bash

iptables -t nat -P PREROUTING ACCEPT
iptables -P INPUT DROP

iptables -F DOCKER-USER

iptables -F DOCKER-INPUT
iptables -X DOCKER-INPUT
iptables -t nat -F DOCKER-BLOCK
iptables -t nat -X DOCKER-BLOCK


iptables -t nat -N DOCKER-BLOCK
iptables -t nat -I PREROUTING -m addrtype --dst-type LOCAL -j RETURN
iptables -t nat -I PREROUTING -m addrtype --dst-type LOCAL -j DOCKER-BLOCK
iptables -t nat -A DOCKER-BLOCK -p tcp -m state --state NEW -m multiport --dports {{ tcp_ports_allowed | replace(' ', '') }} -j DOCKER
iptables -t nat -A DOCKER-BLOCK -p udp -m state --state NEW -m multiport --dports {{ udp_ports_allowed | replace(' ', '') }} -j DOCKER


iptables -N DOCKER-INPUT
iptables -I INPUT -j DOCKER-INPUT
iptables -A DOCKER-INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A DOCKER-INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A DOCKER-INPUT -p tcp -m state --state NEW -m multiport --dports {{ tcp_ports_allowed | replace(' ', '') }} -j ACCEPT
iptables -A DOCKER-INPUT -p udp -m state --state NEW -m multiport --dports {{ udp_ports_allowed | replace(' ', '') }} -j ACCEPT

