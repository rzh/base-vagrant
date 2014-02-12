
This is the GSSAPI/Kerberos test environment.

Host:
- kdc: KDC for Kerberos
- rhel64: CentOS 6.4 MongoD host, start mongod with GSSAPI by executing
<pre>
./mongodb/bin/mongod --config=mongod.conf
</pre>
- client: test client for GSSAPI. Execution following command to login with GSSAPI
<pre>
mongo --host=rhel64 --authenticationMechanism=GSSAPI --authenticationDatabase='$external' --username gssapitest@MONGOTEST.COM
</pre>

