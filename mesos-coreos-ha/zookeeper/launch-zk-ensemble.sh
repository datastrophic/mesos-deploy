#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR

while getopts "fp" opt; do
  case $opt in
    f)
      echo "=> destroying vagrant boxes"
      vagrant destroy -f
      ;;
    p)
      echo "=> provision only"
      ansible-playbook playbook.yml -i hosts.zk -c ssh -u vagrant --private-key=~/.vagrant.d/insecure_private_key
      exit
      ;;
  esac
done

vagrant up

ansible-playbook playbook.yml -i hosts.zk -c ssh -u vagrant --private-key=~/.vagrant.d/insecure_private_key