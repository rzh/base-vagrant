#!/bin/bash

function error_disp() {
    echo -e "\t" '===================================================='
    echo -e "\t $@ failed, check above for deets"
    echo -e "\t" '===================================================='
}

function run_command() {
    $@
     if [ $? != 0 ]; then
         error_disp $@
         exit
     fi  
}

# Install everything section
# ret 0 on most everything, so not great indicator
run_command sudo yum -y install openldap-servers openldap-clients openldap-devel python-devel gcc cyrus-sasl-plain xfsprogs net-snmp ps-misc wget python-setuptools
# ret 1 on err
run_command sudo easy_install pip
run_command sudo pip install python-ldap
# Just in case
sudo service slapd stop
# Destroy everything section
# Get rid of the openldap database
# sudo su - root -c "rm -f /var/lib/ldap/*"
# sudo su - root -c "rm -rf /etc/openldap/slapd.d/*"
# Install our specific one (ret 1 on err)
# run_command sudo slapadd -v -n0 -F /etc/openldap/slapd.d -l mongod.ldif 
run_command sudo service slapd start
#sigh
sleep 10
run_command sudo ldapadd -Y EXTERNAL -H ldapi:/// -f  pw.ldif
# Make sure slapd can start
# sudo chown -R ldap:ldap /etc/openldap/slapd.d
# Add our specifics
run_command ldapadd -x -D "cn=Manager,dc=10gen,dc=me" -w password -f Domain.ldif 
run_command ldapadd -x -D "cn=Manager,dc=10gen,dc=me" -w password -f Users.ldif 
# setup saslauthd
run_command sudo sed -i 's/MECH=pam/MECH=ldap/' /etc/sysconfig/saslauthd
sudo cp saslauthd.conf /etc/
run_command sudo service saslauthd start
# Add the users
echo bugs > users
echo features >> users
echo dbadmin >> users
python ldapconfig.py -f users 
# test the connection
run_command testsaslauthd -u bugs -p password -s mongod -f /var/run/saslauthd/mux
#Show your work!
ldapsearch -x -LLL -b dc=10gen,dc=me
ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts
#python-ldap.x86_64
