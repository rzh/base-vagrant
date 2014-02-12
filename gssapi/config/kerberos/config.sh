#! /bin/bash

set -e
set -x

HOST_FQDN=`hostname`
HOST_NAME=`hostname | cut -d. -f 1 | tr '[:upper:]' '[:lower:]'`
KDC_REALM=MONGOTEST.COM
KDC_DOMAIN=mongotest.com
PASSWORD=aaaAAA111
HOST_IP_ADDR=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | tail -1`
