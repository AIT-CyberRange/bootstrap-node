
# Create AECID domain
openstack domain create AECID

# Create projects in AECID domain
openstack project create --domain AECID AECID-admin

openstack project create --domain AECID Playground
openstack project create --domain AECID Testbed
openstack project create --domain AECID Testbed-Dev
openstack project create --domain AECID AInception

openstack project create --domain AECID wurzenbergerm
openstack project create --domain AECID landauerm
openstack project create --domain AECID hotwagnerw
openstack project create --domain AECID altonl

# Create users in AECID domain
openstack user create --password PquKQPjzRbc9DCMwd78P --domain AECID AECID-admin

openstack user create --password EGSzRbc9pVyAjwvxK8UQ --domain AECID wurzenbergerm
openstack user create --password pBqqQhUKvPquKQPj9xWj --domain AECID landauerm
openstack user create --password znyYSzM8PpaUsKJPaSSp --domain AECID hotwagnerw
openstack user create --password dwzWqDCMwd72fEBPrhhk --domain AECID altonl

# Add roles for AECID users
openstack role add --project AECID-admin --user AECID-admin admin

openstack role add --project wurzenbergerm --user wurzenbergerm admin
openstack role add --project Playground --user wurzenbergerm admin
openstack role add --project Testbed --user wurzenbergerm admin
openstack role add --project Testbed-Dev --user wurzenbergerm admin
openstack role add --project AInception --user wurzenbergerm admin

openstack role add --project landauerm --user landauerm admin
openstack role add --project Playground --user landauerm admin
openstack role add --project Testbed --user landauerm admin
openstack role add --project Testbed-Dev --user landauerm admin
openstack role add --project AInception --user landauerm admin

openstack role add --project hotwagnerw --user hotwagnerw admin
openstack role add --project Playground --user hotwagnerw admin
openstack role add --project Testbed --user hotwagnerw admin
openstack role add --project Testbed-Dev --user hotwagnerw admin
openstack role add --project AInception --user hotwagnerw admin

openstack role add --project altonl --user altonl admin
openstack role add --project Playground --user altonl admin
openstack role add --project Testbed --user altonl admin
openstack role add --project Testbed-Dev --user altonl admin
openstack role add --project AInception --user altonl admin

# Create standard public flavors
openstack flavor create --ram 512 --disk 1 --vcpus 1 m1.tiny
openstack flavor create --ram 2048 --disk 20 --vcpus 1 m1.small
openstack flavor create --ram 4096 --disk 40 --vcpus 2 m1.medium
openstack flavor create --ram 8192 --disk 80 --vcpus 4 m1.large
openstack flavor create --ram 16384 --disk 160 --vcpus 8 m1.xlarge

# Create cirros image
wget -O /tmp/cirros-0.6.2-x86_64-disk.img https://download.cirros-cloud.net/0.6.2/cirros-0.6.2-x86_64-disk.img
openstack image create --container-format bare --disk-format qcow2 --file /tmp/cirros-0.6.2-x86_64-disk.img --public --progress cirros-0.6.2-x86_64-disk.img
rm /tmp/cirros-0.6.2-x86_64-disk.img

# Create ubuntu 22.04 image
wget -O /tmp/jammy-server-cloudimg-amd64.img https://cloud-images.ubuntu.com/jammy/20240403/jammy-server-cloudimg-amd64.img
openstack image create --container-format bare --disk-format qcow2 --file /tmp/jammy-server-cloudimg-amd64.img --public --progress jammy-server-cloudimg-amd64.img
rm /tmp/jammy-server-cloudimg-amd64.img

# Create provider network
openstack network create --no-share --enable --project AECID-admin --project-domain AECID --provider-network-type vlan --provider-physical-network physnet1 --provider-segment 110 AECID-provider-network
openstack subnet create --network AECID-provider-network --project AECID-admin --project-domain AECID --subnet-range 10.110.0.0/24 --dhcp --gateway 10.110.0.1 10.110.0.0/24


openstack network rbac create --type network --action access_as_shared --target-project wurzenbergerm --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project landauerm --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project hotwagnerw --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project altonl --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project Playground --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project Testbed --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project Testbed-Dev --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network
openstack network rbac create --type network --action access_as_shared --target-project AInception --target-project-domain AECID --project AECID-admin --project-domain AECID AECID-provider-network

openstack security group create --project-domain AECID --project AECID SSH-and-PING
openstack security group rule create --protocol icmp --project-domain AECID --project AECID-admin b40356d2-9d33-4c59-b089-518ffaf53ec1
openstack security group rule create --protocol tcp --dst-port 22 --project-domain AECID --project AECID-admin b40356d2-9d33-4c59-b089-518ffaf53ec1
