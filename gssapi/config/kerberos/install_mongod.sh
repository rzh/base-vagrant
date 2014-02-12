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

echo "dbpath=/home/vagrant/dbs" >> /home/vagrant/mongod.conf
echo "auth = true"  >> /home/vagrant/mongod.conf
echo "setParameter = authenticationMechanisms=GSSAPI"  >> /home/vagrant/mongod.conf
echo "# setParameter = authenticationMechanisms=MONGODB-CR"  >> /home/vagrant/mongod.conf
echo "# setParameter = authenticationMechanisms=CRAM-MD5"  >> /home/vagrant/mongod.conf
echo "# sslOnNormalPorts = true"  >> /home/vagrant/mongod.conf
echo "# sslPEMKeyFile = /vagrant/mongodb.pem"  >> /home/vagrant/mongod.conf

echo "export KRB5_KTNAME=\"/vagrant/shared/mongod_$HOST_NAME.keytab\"" >> /home/vagrant/.bash_profile

echo "get mongo enterprise"
if [ -f /etc/redhat-release ]; then
	if grep -q "release 6.. (Final)" /etc/redhat-release
	then
	    # this is 6.4 release
		echo "get mongod enterprise latest nightly"
		wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		tar zxvf mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		rm mongodb-linux-x86_64-enterprise-rhel62-latest.tgz
		mv mongodb-linux-x86_64-enterprise-rhel62-* mongodb
	elif grep -q "release 5.. (Final)" /etc/redhat-release
		# redhat 5.x release
		wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		tar zxvf mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		rm mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		mv mongodb-linux-x86_64-enterprise-rhel57-* mongodb
	fi
fi

echo "restore dbs"
cp -r /vagrant/shared/dump /home/vagrant
echo "create database folder"
mkdir /home/vagrant/dbs
chmod 777 /home/vagrant/dbs

/home/vagrant/mongodb/bin/mongorestore --dbpath /home/vagrant/dbs

echo "cleanup...."
if [ -f /home/vagrant/*.tgz ]; then
	rm /home/vagrant/*.tgz
fi

chown -R vagrant:vagrant /home/vagrant/*

