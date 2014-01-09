#! /bin/bash

set -e
set -x

echo "Exporting env variables"
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/config.sh

echo "Configuring /etc/hosts ..."
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1 	localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "$CLIENT_IP_ADDR    $CLIENT_FQDN $CLIENT_NAME" >> /etc/hosts

echo "Downloading some packages ..."
yum install systat openssl  -y

# get mongodb
wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.8.tgz
tar zxvf mongodb-linux-x86_64-2.4.8.tgz


