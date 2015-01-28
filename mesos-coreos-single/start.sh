#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR

while getopts "fp" opt; do
  case $opt in
    f)
      echo ":=> destroying vagrant boxes"
      vagrant destroy -f
      ;;
  esac
done

DISCOVERY_TOKEN=`curl -s https://discovery.etcd.io/new` && perl -i -p -e "s@discovery: https://discovery.etcd.io/\w+@discovery: $DISCOVERY_TOKEN@g" user-data

> ~/.fleetctl/known_hosts

export FLEETCTL_TUNNEL=127.0.0.1:2222

vagrant up

fleetctl submit service/{zookeeper,mesos-master,mesos-slave,marathon}.service

fleetctl start {zookeeper,mesos-master,mesos-slave,marathon}.service