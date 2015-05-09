#!/bin/sh

export ANSIBLE_HOST_KEY_CHECKING=False

#to run this against brand new cluster 'ansible' user should be created with passwordless sudo privileges
#and your public key (this can be automated with 'user-data' on many cloud providers)
ansible-playbook playbook.yml -i hosts -c ssh -u ansible --private-key=~/.ssh/id_rsa