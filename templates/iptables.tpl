iptables -t nat -P PREROUTING ACCEPT
iptables -P INPUT DROP

iptables -F DOCKER-USER
iptables -F DOCKER-INPUT

iptables -t nat -N DOCKER-BLOCK

iptables -t nat -I PREROUTING -m addrtype --dst-type LOCAL -j RETURN
iptables -t nat -I PREROUTING -m addrtype --dst-type LOCAL -j DOCKER-BLOCK
iptables -t nat -A DOCKER-BLOCK -p tcp -m state --state NEW -m multiport --dports {{ tcp_ports_allowed }} -j DOCKER
iptables -t nat -A DOCKER-BLOCK -p udp -m state --state NEW -m multiport --dports {{ udp_ports_allowed }} -j DOCKER


iptables -N DOCKER-INPUT
iptables -I INPUT -j DOCKER-INPUT
iptables -A DOCKER-INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A DOCKER-INPUT -p tcp -m state --state NEW -m multiport --dports {{ tcp_ports_allowed }} -j ACCEPT
iptables -A DOCKER-INPUT -p udp -m state --state NEW -m multiport --dports {{ udp_ports_allowed }} -j ACCEPT