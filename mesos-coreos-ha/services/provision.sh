#!/bin/bash -e

ZK_INSTANCE_NUM=3
MESOS_MASTER_NUM=3

SERVICES=(
    marathon mesos-slave
)

function reload_zookeeper_units {
    for i in `seq $ZK_INSTANCE_NUM`; do
        fleetctl destroy zookeeper@$i
        fleetctl destroy zookeeper-sidekick@$i
    done

    fleetctl destroy zookeeper@
    fleetctl submit zookeeper@.service
    fleetctl destroy zookeeper-sidekick@
    fleetctl submit zookeeper-sidekick@.service
}

function reload_mesos_master_units {
    for i in `seq $MESOS_MASTER_NUM`; do
        fleetctl destroy mesos-master@$i
    done

    fleetctl destroy mesos-master@
    fleetctl submit mesos-master@.service
}

function start_zookeeper_units {
    for i in `seq $ZK_INSTANCE_NUM`; do
        fleetctl start zookeeper@$i
    done
    
    for i in `seq $ZK_INSTANCE_NUM`; do
        fleetctl start zookeeper-sidekick@$i
    done
}

function start_mesos_master_units {
    for i in `seq $MESOS_MASTER_NUM`; do
        fleetctl start mesos-master@$i
    done
}

reload_zookeeper_units
reload_mesos_master_units

#Destroying non-template Units
for service in ${SERVICES[*]}; do
	fleetctl destroy ${service}
done

sleep 5

start_zookeeper_units

sleep 5

start_mesos_master_units

sleep 5

#Launch non-template Units
for service in ${SERVICES[*]}; do
	fleetctl start ${service}.service
done