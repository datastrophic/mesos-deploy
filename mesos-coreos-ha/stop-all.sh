#!/bin/sh
NORMAL='\033[0m'      #  ${NORMAL}    # default text setting
RED='\033[0;31m'       #  ${RED}      # red characters


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "${RED}:=> destroying slaves${NORMAL}"
cd $DIR/mesos-slave
vagrant destroy -f

echo "${RED}:=> destroying masters${NORMAL}"
cd $DIR/mesos-master
vagrant destroy -f

echo "${RED}:=> destroying zookeeper${NORMAL}"
cd $DIR/zookeeper
vagrant destroy -f