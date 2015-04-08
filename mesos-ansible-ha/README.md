# Mesos HA deployment with Ansible

### Running
To launch 3-node Mesos Cluster with Marathon just run `vagrant up` from current directory. Mesos Masters must be 
available on all three nodes and have web interface running at [`http://63.76.7.101:5050/`](http://63.76.7.101:5050/) (you will be redirected to
current leader automatically).

#### Non-Vagrant deployment

For deployment to standalone cluster:

  * modify `hosts` file according to cluster-specific nodes addresses and roles
  * Mesos nodes registration in zookeeper is performed with ip addresses, so in different network setups different 
    interfaces can be used. This behavior is controlled with `eth` variable in `group_vars/main.yml` file. Usually `eth0` 
    works in most cases, but Vagrant needs `eth1` for this purpose, so variable's value is overwritten in `provision.sh` script.
    In order to use different interface, override `--extra-vars "eth=eth1"` argument, or remove it in case you want to use
    default one
  * run `provision.sh`

####Web UI addresses and ports

By default next nodes are used for Mesos Masters:

 * [`63.76.7.101:5050`](http://63.76.7.101:5050/)
 * [`63.76.7.102:5050`](http://63.76.7.102:5050/)
 * [`63.76.7.103:5050`](http://63.76.7.103:5050/)

Marathon is launched at [`63.76.7.101:8080`](http://63.76.7.101:8080/)

Mesos Slaves are launched globally at every machine in cluster

###Provisioning in Vagrant
This provisioning is Ansible-centric and Vagrant boxes are tweaked in the next way:

 * each node has `ansible` user with passwordless sudo privileges and host machine user public key (copied 
 from ~/.ssh/id_rsa.pub). This allows you not to bind to Vagrant user and insecure private key and more easily switch 
 to your real hardware cluster
 * Ansible playbook is executed after all hosts are booted up with Vagrant's `host-shell` plugin. `provision.sh` 
 contains ansible-playbook command with corresponding parameters. Inventory file used is `hosts` and in case you change 
   amount of nodes or ip addresses this file must be changed as well.
   
   
### Ansible roles
 * `common` - adds Mesos repositories and sets locales
 * `oracle-java` - installs Java 8 from Oracle
 * `zookeeper`
 * `mesos` - installs and runs Mesos Masters and Slaves depending on machine group and variable `mesos_install_mode` 
 which valid values are `master|slave|mixed`
 * `marathon`
 
Check out [playbook.yml](playbook.yml) and [hosts](hosts) to figure out how roles distribute across cluster nodes
 
