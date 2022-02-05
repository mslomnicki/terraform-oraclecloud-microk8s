#!/bin/bash
# Variables passed to script
PUBLIC_IP=$1

# Build in place inventory file to get rid of warnings
echo "localhost" > ~/ansible/inventory

ansible-playbook -c local -i ~/ansible/inventory ~/ansible/ansible.yaml -e public_ip=$PUBLIC_IP
rm -rf ~/ansible

