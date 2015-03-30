# Mesos HA deployment to CoreOS

### Running
To launch 3-node Mesos Cluster with Marathon just run `vagrant up` from current directory. Mesos Masters must be 
available on all three nodes and have web interface running at [`http://63.76.7.101:5050/`](http://63.76.7.101:5050/) (you will be redirected to
current leader automatically).

####Web UI addresses and ports

By default next nodes are used for Mesos Masters:

 * [`63.76.7.101:5050`](http://63.76.7.101:5050/)
 * [`63.76.7.102:5050`](http://63.76.7.102:5050/)
 * [`63.76.7.103:5050`](http://63.76.7.103:5050/)

Marathon is launched at [`63.76.7.101:8080`](http://63.76.7.101:8080/)

Mesos Slaves are launched globally at every machine in cluster

###Provisioning in Vagrant
Shell provisioner is used to provision Vagrant machines. The whole process of provisioning looks as follows:

  * building docker images and packing them into archives to speed up containers distribution across target nodes. 
  Image rebuild happens only one time if there are no previously built archives in [images](images) folder. This step runs
  only on first container start   
  * Containers are loaded with `docker load` command at every host as part of provision. Sharing containers happens via
   synced NFC folder
  * when the final node is loaded fleet provisioning runs and loads services from [services](services) directory

###Docker
Containers used for deployment:

 * datastrophic/zookeeper
 * mesosphere/mesos-master:0.21.1-1.1.ubuntu1404
 * mesosphere/mesos-slave:0.21.1-1.1.ubuntu1404
 * mesosphere/marathon:v0.7.5

###Configuration
Running `vagrant up` launches 3 CoreOS boxes and provisions them with fleet services:

 * ZooKeeper ensemble of 3 nodes.
 * Mesos Masters. Number of nodes in [services/provision.sh](services/provision.sh) and defaults to 3
 * Mesos Slaves triggered as Global Units and spans all available machines
 * Marathon service

**Notes**:

 * Number of machines in cluster configured in [config.rb](config.rb) with variable `$num_instances`
 * Number of ZooKeeper and Mesos Master nodes configured in [services/provision.sh](services/provision.sh) and
 defaults to 3
 * fleet assigns services to machines according to metadata specified in [config.rb](config.rb) with appropriate configuration of
 `[X-Fleet]` section of service files(`MachineMetadata`). In fact, you can comment out all metadata constraints 
 in service files and then all services will be distributed across the cluster with no guaranteed binding to specific 
  hosts. In this case it is inconvenient having your master and zookeeper nodes launched at random machines in terms of
    configuring ZooKeeper ensemble and Mesos ZK endpoints.
 
###Vagrant and fleet

If you want to run `fleetctl` commands from host machine proper `FLEETCTL_TUNNEL` must be specified. Vagrant maps guest 
 ssh port `22` to host's port `2222` but in case you're running several machines it can be different. Necessary 
 information about port mappings available with `vagrant ssh-config` and should be used for specifying `FLEETCTL_TUNNEL`

        export FLEETCTL_TUNNEL=127.0.0.1:2222
        
Then add vagrant insecure private ssh key to access CoreOS machines with 

        ssh-add ~/.vagrant.d/insecure_private_key
        
After running `fleetctl list-units` your output should look like this:

        UNIT				            MACHINE			        ACTIVE	SUB
        marathon.service		        1243aa1c.../63.76.7.103	active	running
        mesos-master@1.service		    1243aa1c.../63.76.7.103	active	running
        mesos-master@2.service		    6529cb4e.../63.76.7.101	active	running
        mesos-master@3.service		    e85ff743.../63.76.7.102	active	running
        mesos-slave.service		        1243aa1c.../63.76.7.103	active	running
        mesos-slave.service		        6529cb4e.../63.76.7.101	active	running
        mesos-slave.service		        e85ff743.../63.76.7.102	active	running
        zookeeper-sidekick@1.service	1243aa1c.../63.76.7.103	active	running
        zookeeper-sidekick@2.service	6529cb4e.../63.76.7.101	active	running
        zookeeper-sidekick@3.service	e85ff743.../63.76.7.102	active	running
        zookeeper@1.service		        1243aa1c.../63.76.7.103	active	running
        zookeeper@2.service		        6529cb4e.../63.76.7.101	active	running
        zookeeper@3.service		        e85ff743.../63.76.7.102	active	running


 