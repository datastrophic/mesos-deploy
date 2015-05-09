# Mesos HA deployment with Ansible

### Running
To launch 3-node Mesos Cluster with Marathon just run `vagrant up` from current directory. Mesos Masters must be 
available on all three nodes and have web interface running at [`http://mesos-01.local:5050/`](http://mesos-01.local:5050/) (you will be redirected to
current leader automatically).

Host names automatically added to `/etc/hosts` by Vagrant `host-manager` plugin

#### Non-Vagrant deployment

For deployment to standalone cluster:

  * verify that cluster nodes hostnames resolve to proper ip addresses. 
  This is needed for proper Mesos nodes registration and ip advertizing in ZooKeeper
  * modify `hosts` file according to cluster-specific nodes addresses and roles
  * run `provision.sh`

####Web UI addresses and ports

By default next nodes are used for Mesos Masters:

 * [`mesos-01.local:5050`](http://mesos-01.local:5050/)
 * [`mesos-02.local:5050`](http://mesos-02.local:5050/)
 * [`mesos-03.local:5050`](http://mesos-03.local:5050/)

Marathon is launched at [`mesos-01.local:8080`](http://mesos-01.local:8080/)

Mesos Slaves are launched globally at every machine in cluster

###Provisioning in Vagrant
This provisioning is Ansible-centric and Vagrant boxes are tweaked in the next way:

 * each node has `ansible` user with passwordless sudo privileges and host machine user public key (copied 
 from ~/.ssh/id_rsa.pub). This allows you not to bind to Vagrant user and insecure private key and more easily switch 
 to your real hardware cluster
 * Ansible playbook is executed after all hosts are booted up with Vagrant's `host-shell` plugin. `provision.sh` 
 contains ansible-playbook command with corresponding parameters. Inventory file used is `hosts` and in case you change 
   amount of nodes this file must be changed as well.
   
   
### Ansible roles
 * `common` - adds Mesos repositories and sets locales
 * `oracle-java` - installs Java 8 from Oracle
 * `zookeeper`
 * `mesos` - installs and runs Mesos Masters and Slaves depending on machine group and variable `mesos_install_mode` 
 which valid values are `master|slave|mixed`
 * `marathon`
 
Check out [playbook.yml](playbook.yml) and [hosts](hosts) to figure out how roles distribute across cluster nodes
 
