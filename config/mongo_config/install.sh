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

echo "config and enable port for mongo services"

# echo "get & install mongodb"
# wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.8.tgz
# tar zxvf mongodb-linux-x86_64-2.4.8.tgz

echo "get mongod latest nightly"
wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-latest.tgz
tar zxvf mongodb-linux-x86_64-latest.tgz

echo "get mongod enterprise latest nightly"
wget http://downloads.10gen.com/linux/mongodb-linux-x86_64-enterprise-rhel62-2.5.5.tgz
tar zxvf mongodb-linux-x86_64-enterprise-rhel62-2.5.5.tgz

echo "create mongod.conf"
echo "# auto generated mongod config " > /home/vagrant/mongod.conf
echo "dbpath=/home/vagrant/dbs" >> /home/vagrant/mongod.conf

echo "create database folder"
mkdir /home/vagrant/dbs
