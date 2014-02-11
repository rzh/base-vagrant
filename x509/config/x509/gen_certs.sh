#!/bin/bash 

set -e
set -x

#setup a bunch of openSSL certs for easy testing

SUBJ="/C=US/ST=California/L=Palo Alto/O=MongoDB/OU=QA/CN=TEST-338-CA"
SUBJ_CLIENT="/C=US/ST=California/L=Palo Alto/O=MongoDB/OU=QAClient/CN=TEST-338-CLIENT"
SUBJ_SERVER="/C=US/ST=California/L=Palo Alto/O=MongoDB/OU=QA/CN=TEST-338-SERVER"

BASEDIR=/home/vagrant/testCA

# Set up CA directory structure
echo "Setting up the directories"
mkdir $BASEDIR
echo "testCA"
mkdir $BASEDIR/certs
echo "testCA/certs"
mkdir $BASEDIR/private
echo "testCA/private"
mkdir $BASEDIR/newcerts
echo "testCA/libs"
mkdir $BASEDIR/libs
mkdir $BASEDIR/tmp
echo "testCA/newcerts"
echo "Setting the permission to 700 on testCA"
sudo chmod -R 700 /home/vagrant/

echo 1000 > $BASEDIR/serial
touch $BASEDIR/index.txt

# Create valid certificates, creating keys, reqs, and crts in this directory and depositing PEMs into libs/
echo "Creating the CA"
openssl req -new -nodes -x509 -days 365 -out $BASEDIR/cacert.pem -keyout $BASEDIR/private/cakey.pem -subj "$SUBJ" -config /vagrant/config/x509/openssl.cnf

echo "Creating server certificate"
openssl req -newkey rsa:1024 -nodes -sha1 -keyout $BASEDIR/testServer.key -keyform PEM -out $BASEDIR/testServer.req -outform PEM -subj "$SUBJ_SERVER" -config /vagrant/config/x509/openssl.cnf
yes | openssl ca -in $BASEDIR/testServer.req -out $BASEDIR/testServer.crt -config /vagrant/config/x509/openssl.cnf
cat $BASEDIR/testServer.crt $BASEDIR/testServer.key > $BASEDIR/libs/server_338.pem

echo "Creating client certificate"
openssl req -newkey rsa:1024 -nodes -sha1 -keyout $BASEDIR/testClient.key -keyform PEM -out $BASEDIR/testClient.req -outform PEM -subj "$SUBJ_CLIENT"  -config /vagrant/config/x509/openssl.cnf
yes | openssl ca -in $BASEDIR/testClient.req -out $BASEDIR/testClient.crt -config /vagrant/config/x509/openssl.cnf
cat $BASEDIR/testClient.crt $BASEDIR/testClient.key > $BASEDIR/libs/client_338.pem

echo "copying CA key file"
cp $BASEDIR/cacert.pem $BASEDIR/libs/ca_338.pem

# Cleanup
#rm -f $BASEDIR/*.key 
#rm -f $BASEDIR/*.crt 
#rm -f $BASEDIR/*.req

# Print out certificate subjects
echo "Your subjects, O king --"
echo "** SERVER"
sudo openssl x509 -in $BASEDIR/libs/server_338.pem -inform PEM -subject -nameopt RFC2253
echo "** CLIENT"
sudo openssl x509 -in $BASEDIR/libs/client_338.pem -inform PEM -subject -nameopt RFC2253

# Show what we did
echo "Created three valid certificates":
echo "        ca_338.pem              CA certificate"
echo "        server_338.pem          Server certificate"
echo "        client_338.pem          Client certificate"
