#! /bin/bash

set -e
set -x

echo "generate ssl pem key"
cd /etc/ssl/
openssl req -new -x509 -days 365 -nodes -out mongodb-cert.crt -keyout mongodb-cert.key -subj '/C=US/ST=NY/L=NYC/CN=www.mongodb.com'
cat mongodb-cert.key mongodb-cert.crt > mongodb.pem

echo "Now append ssl config to mongod.conf"
echo "sslOnNormalPorts = true" >> /home/vagrant/mongod.conf
echo "sslPEMKeyFile = /etc/ssl/mongodb.pem" >> /home/vagrant/mongod.conf
