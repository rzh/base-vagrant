#! /bin/bash

set -e
set -x


echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh


# echo "config NTP server"
# chkconfig ntpd on

echo "config firewall"

# echo "Configuring firewalld ..."
#
# following port are needed for kerberos to work
# Please make sure the following ports are opened in the firewall settings:
#      TCP: 80, 88, 389
#      UDP: 88 (at least one of TCP/UDP ports 88 has to be open)
# Also note that following ports are necessary for ipa-client working properly after enrollment:
#      TCP: 464
#      UDP: 464, 123 (if NTP enabled)

# iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 88 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 389 -j ACCEPT
# iptables -A INPUT -p udp -m udp --dport 88 -j ACCEPT
# iptables -A INPUT -p udp -m udp --dport 464 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 464 -j ACCEPT

# open port for mongod
# iptables -A INPUT -p tcp -m tcp --dport 27017 -j ACCEPT


echo "config DNS"
echo "Configuring /etc/hosts ..."
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1   localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
# echo "$HOST_IP_ADDR    $HOST_FQDN $HOST_NAME" >> /etc/hosts

echo "config client DNS"
bash $DIR/../config_dns.sh

if [ -f /etc/redhat-release ]
then
	# redhat
	service iptables stop
	chkconfig iptables off
elif [ -f /etc/lsb-release ]; then
	# ubuntu
	ufw disable
fi