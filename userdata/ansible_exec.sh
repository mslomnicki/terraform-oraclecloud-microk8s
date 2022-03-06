#!/bin/bash
# Variables passed to script
PRIVATE_IP=$1
PUBLIC_IP=$2
SUBNET_CIDR=$3
MGMT_ADDRESS=$4

# Build in place inventory file to get rid of warnings
echo "localhost" > ~/ansible/inventory

ansible-playbook -c local -i ~/ansible/inventory ~/ansible/ansible.yaml -e private_ip=$PRIVATE_IP -e public_ip=$PUBLIC_IP -e subnet_cidr=$SUBNET_CIDR -e mgmt_address=$MGMT_ADDRESS
rm -rf ~/ansible

