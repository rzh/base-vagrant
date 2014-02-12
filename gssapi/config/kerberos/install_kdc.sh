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
	yum install krb5-server krb5-libs krb5-workstation -y
else 
	echo "++++++++++++++++++++++++"
	echo "KDC Must be Rhel!!"
	echo "++++++++++++++++++++++++"
fi

echo "==> config kdc"
echo "update krb5.conf"
sed -i 's/EXAMPLE/MONGOTEST/g' /etc/krb5.conf
sed -i 's/example/mongotest/g' /etc/krb5.conf
sed -i 's/kerberos.mongotest.com/kdc.mongotest.com/g' /etc/krb5.conf

sed -i 's/EXAMPLE/MONGOTEST/g' /var/kerberos/krb5kdc/kdc.conf
sed -i 's/EXAMPLE/MONGOTEST/g' /var/kerberos/krb5kdc/kadm5.acl

echo "modify entropy source"
rngd -r /dev/urandom -o /dev/random -b -t 1

echo "create a new database"
kdb5_util create -s -P $PASSWORD

echo "create keytab for all mongod"

echo "start service"
service krb5kdc start
service kadmin start
service iptables stop
chkconfig iptables off

kadmin.local -q "addprinc admin/admin" <<!
aaaAAA111
aaaAAA111
!

kadmin.local -q "addprinc gssapitest" <<!
aaaAAA111
aaaAAA111
!

kadmin.local -q "addprinc gssapitest1" <<!
aaaAAA111
aaaAAA111
!

echo "create principle for mongod_rh64 mongodb"
kadmin.local -q "addprinc mongodb/rhel64.mongotest.com" <<!
aaaAAA111
aaaAAA111
!

echo "create keytab for mongod rhel64"
kadmin.local -q "ktadd -k mongod_rhel64.keytab mongodb/rhel64.mongotest.com"
mv mongod_rhel64.keytab  /vagrant/shared
chown vagrant:vagrant /vagrant/shared/mongod_rhel64.keytab
