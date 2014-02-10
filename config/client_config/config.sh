#! /bin/bash

set -e
set -x

export CLIENT_IP_ADDR=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | tail -1`
export CLIENT_FQDN=`hostname`
export CLIENT_NAME=`hostname | cut -d. -f 1 | tr '[:upper:]' '[:lower:]'`
