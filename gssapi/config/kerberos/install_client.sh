#! /bin/bash

set -e
set -x

echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh

echo "execute common installation tasks"
bash $DIR/install_kerberos_common.sh

if [ -f /etc/redhat-release ]
then
	echo "install krb5 packages"
	yum install krb5-libs krb5-workstation -y
fi

echo "install mongod enterprise needed package"
if [ -f /etc/redhat-release ]; then
	sudo yum install openssl net-snmp net-snmp-libs net-snmp-utils cyrus-sasl cyrus-sasl-lib cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-md5 -y
fi

echo "update krb5.conf"
sed -i 's/EXAMPLE/MONGOTEST/g' /etc/krb5.conf
sed -i 's/example/mongotest/g' /etc/krb5.conf
sed -i 's/kerberos.mongotest.com/kdc.mongotest.com/g' /etc/krb5.conf

echo "get mongo enterprise"
if [ -f /etc/redhat-release ]; then
	if grep -q "6.4" /etc/redhat-release
	then
	    # this is 6.4 release
		echo "get mongod enterprise latest nightly"
		wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		tar zxvf mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		rm mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		mv mongodb-linux-x86_64-enterprise-rhel62-* mongodb
	fi
fi

