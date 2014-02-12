#!/bin/bash

echo "Configuring /etc/hosts ..."
echo "192.168.19.100	kdc.mongotest.com kdc"   >> /etc/hosts
echo "192.168.19.101	rhel64.mongotest.com rhel64"   >> /etc/hosts
echo "192.168.19.102	rhel58.mongotest.com rhel58"   >> /etc/hosts
echo "192.168.19.150	client.mongotest.com client"   >> /etc/hosts

