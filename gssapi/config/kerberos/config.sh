#! /bin/bash

set -e
set -x

export HOST_FQDN=`hostname`
export HOST_NAME=`hostname | cut -d. -f 1 | tr '[:upper:]' '[:lower:]'`
export KDC_REALM=MONGOTEST.COM
export KDC_DOMAIN=mongotest.com
export PASSWORD=aaaAAA111
export HOST_IP_ADDR=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | tail -1`
