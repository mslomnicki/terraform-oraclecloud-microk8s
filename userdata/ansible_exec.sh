#!/bin/bash
# Build in place inventory file to get rid of warnings
echo "localhost" > ~/ansible/inventory

ansible-playbook -c local -i ~/ansible/inventory ~/ansible/ansible.yaml
#rm -rf ~/ansible

