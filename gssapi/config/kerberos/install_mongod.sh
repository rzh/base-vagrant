#! /bin/bash

set -e
set -x

echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh

echo "execute common installation tasks"
bash $DIR/install_kerberos_common.sh

echo "install mongod enterprise needed package"
if [ -f /etc/redhat-release ]; then
	if grep -q "CentOS release 5." /etc/redhat-release; then
		# redhat 5.x need configure /etc/resolvr.conf to get DNS working
		echo "nameserver 10.0.2.3" > /etc/resolv.conf
		chmod -w /etc/resolv.conf
	fi

	echo "install krb5 packages"
	yum install krb5-libs krb5-workstation -y

	echo "install enterprise needed module"
	sudo yum install openssl net-snmp net-snmp-libs net-snmp-utils cyrus-sasl cyrus-sasl-lib cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-md5 -y
elif [ -f /etc/lsb-release ]; then
	# ubuntu

	# apt-get install krb5-user  -y 
	apt-get install libssl0.9.8 snmp snmpd cyrus-sasl2-dbg cyrus-sasl2-mit-dbg libsasl2-2 libsasl2-dev libsasl2-modules libsasl2-modules-gssapi-mit -y
elif [ -f /etc/SuSE-release ]; then
	# Suse
	sudo rpm -i /vagrant/shared/suse/snmp-mibs-5.4.2.1-8.1.x86_64.rpm
	sudo rpm -i /vagrant/shared/suse/libsensors3-2.10.6-10.15.x86_64.rpm
	sudo rpm -i /vagrant/shared/suse/libsnmp15-5.4.2.1-8.1.x86_64.rpm
	sudo rpm -U /vagrant/shared/suse/libopenssl0_9_8-0.9.8j-0.44.1.x86_64.rpm
	sudo rpm -i /vagrant/shared/suse/libopenssl0_9_8-hmac-0.9.8j-0.44.1.x86_64.rpm
	sudo rpm -U /vagrant/shared/suse/openssl-0.9.8j-0.44.1.x86_64.rpm
fi


# echo "update krb5.conf"
# sed -i 's/EXAMPLE/MONGOTEST/g' /etc/krb5.conf
# sed -i 's/example/mongotest/g' /etc/krb5.conf
# sed -i 's/kerberos.mongotest.com/kdc.mongotest.com/g' /etc/krb5.conf

echo "copy krb5.conf"
cp /vagrant/shared/krb5.conf /etc

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
	then
		# redhat 5.x release
		wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		tar zxvf mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		rm mongodb-linux-x86_64-enterprise-rhel57-latest.tgz
		mv mongodb-linux-x86_64-enterprise-rhel57-* mongodb
	fi
elif [ -f /etc/lsb-release ] 
then
	# ubuntu
	wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1204-latest.tgz
	tar zxvf mongodb-linux-x86_64-enterprise-ubuntu1204-latest.tgz
	rm mongodb-linux-x86_64-enterprise-ubuntu1204-latest.tgz
	mv mongodb-linux-x86_64-enterprise-ubuntu1204-* mongodb
elif [ -f /etc/SuSE-release ]; then
	# Suse
	wget http://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-suse11-latest.tgz
	tar zxvf mongodb-linux-x86_64-enterprise-suse11-latest.tgz
	rm mongodb-linux-x86_64-enterprise-suse11-latest.tgz
	mv mongodb-linux-x86_64-enterprise-suse11-* mongodb
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

if [ -f /etc/SuSE-release ]; then
	# Suse
	chown -R vagrant:users /home/vagrant/*
else
	chown -R vagrant:vagrant /home/vagrant/*
fi

