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

echo "update krb5.conf"
sed -i 's/EXAMPLE/MONGOTEST/g' /etc/krb5.conf
sed -i 's/example/mongotest/g' /etc/krb5.conf
sed -i 's/kerberos.mongotest.com/kdc.mongotest.com/g' /etc/krb5.conf
