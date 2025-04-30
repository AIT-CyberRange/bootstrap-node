# openstack image create --disk-format qcow2 --container-format bare --file images/ubuntu-root.qcow2 ubuntu22
# openstack flavor create --vcpus 1 --ram 1024 --disk 10 small

openstack network create int
openstack subnet create --network int --subnet-range 10.0.0.0/24 int-sn

openstack network create --external --provider-physical-network physnet1 ext
openstack subnet create --network ext --subnet-range 192.168.4.0/24 --gateway 192.168.4.254 --allocation-pool 192.168.4.101,end=192.168.4.200 ext-sn

openstack server create --flavor small --image ubuntu22 --user-data ~/images/admin-ci.cfg vm1
openstack server create --flavor small --image ubuntu22 --user-data ~/images/admin-ci.cfg vm2
