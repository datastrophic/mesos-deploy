require 'open-uri'
# Renew the discovery token each time to prevent having a stale cluster
$token = open('https://discovery.etcd.io/new').read

# Size of the CoreOS cluster created by Vagrant
$num_instances=3

# The fleet metadata to map for each instance
$fleetmeta = {
  1 => 'zookeeper=true,mesos-master=true,marathon=true',
  2 => 'zookeeper=true,mesos-master=true',
  3 => 'zookeeper=true,mesos-master=true'
}

# Official CoreOS channel from which updates should be downloaded
$update_channel='stable'

# Other Ports to open on all VMs
$forward_ports = [5050, 8080, 8081]




