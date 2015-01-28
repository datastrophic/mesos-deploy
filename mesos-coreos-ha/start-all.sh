#!/bin/sh

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $DIR

. ./config.sh

#TODO: join mesos masters and slaves in one CoreOS config plus meta to deploy mesos cluster at once