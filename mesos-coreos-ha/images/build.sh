#!/bin/sh

cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# List of Docker images being archived
# for faster distribution across VMs
CONTAINERS=(
    datastrophic/zookeeper
    mesosphere/mesos-master:0.21.1-1.1.ubuntu1404
    mesosphere/mesos-slave:0.21.1-1.1.ubuntu1404
    mesosphere/marathon:v0.7.5
)

for container in ${CONTAINERS[*]}; do
    NAME=`echo ${container} | cut -d/ -f2 | cut -d: -f1`

    if [ ! -e "$NAME.tar" ]; then
        docker pull ${container}
        docker save -o ${NAME}.tar ${container}
    fi

done