1. General info
    1.1. Technology 
    1.2. Physical hardware
        1.2.1. Servers
        1.2.2. Switches

2. Architecture
    2.1. Kayobe host
    2.2. Kayobe VM
    2.3. Networking
        2.3.1. Physical
        2.3.2. Logical
        2.3.3. Addressation

3. Configuration
    3.1. Baremetal server configuration
    3.2. UTS-playbooks configuration
    3.3. TODO: Kayobe configuration (is this needed?)
    3.4. TODO: Switch configuraion (is this needed or part 2.3.2. is enough?)

4. Installation process
    4.1. Prerequisites
    4.2. uts-playbooks
        4.2.1. Playbook provision_kayobevm.yml
        4.2.2. Playbook provision_overcloud.yml
    4.3. Post-deployment resources

5. Procedure manuals
    5.1. New project onboarding
    5.2. Adding new node to cluster
    5.3. Reinstalling node
    5.4. Kolla service reconfiguration

6. Monitoring and alerting
    6.1. Prometheus architecture
    6.2. Alertmanager architecture
    6.3. Grafana architecture
    6.4. Grafana dashboard walkthrough

-----------

1. General info
    1.1. Technology

    Technologies used in documented cluster:
    - Kayobe (https://docs.openstack.org/kayobe/latest/)
    - Kolla Ansible (https://docs.openstack.org/kayobe/latest/)
    - Custom Ansible Playbooks 


    1.2. Physical hardware

        1.2.1. Servers

        S3LS2401 - Kayobe Host
            PowerEdge R250
            1x Intel Xeon E-2378
            2x 00CE00000C01 M391A1K43DB2-CWE 8GB
            2x SEAGATE BL600MM0069 600GB RAID-1
            2x Broadcom BCM5720 Gigabit Ethernet
            
            iDRAC IP: 192.168.3.10

        S3LS211
            PowerEdge R740xd
            2x Intel Xeon Silver 4214R
            16x Micron 18ASF4G72PDZ-3G2B2 32GB
            6x SK Hynix / DELL HFS480G3H2X069N 480GB RAID-5 with 1 hot spare
            2x Broadcom BCM5720 Gigabit Ethernet PCIe
            2x Broadcom BCM57416 NetXtreme-E Dual-Media 10G

            iDRAC IP: 192.168.3.11
            
        S3LS212
            PowerEdge R740xd
            2x Intel Xeon Silver 4214R
            16x Hynix HMAA4GR7CJR8N-XN 32GB
            6x SK Hynix / DELL HFS480G3H2X069N 480GB RAID-5 with 1 hot spare
            2x Broadcom BCM5720 Gigabit Ethernet PCIe
            2x Broadcom BCM57416 NetXtreme-E Dual-Media 10G

            iDRAC IP: 192.168.3.12

        S3LS213
            PowerEdge R740xd
            2x Intel Xeon Silver 4214R
            16x Hynix HMAA4GR7CJR8N-XN 32GB
            6x SK Hynix / DELL HFS480G3H2X069N 480GB RAID-5 with 1 hot spare
            2x Broadcom BCM5720 Gigabit Ethernet PCIe
            2x Broadcom BCM57416 NetXtreme-E Dual-Media 10G

            iDRAC IP: 192.168.3.13

        S3LS214
            PowerEdge R740xd
            2x Intel Xeon Silver 4214R
            16x Hynix HMAA4GR7CJR8N-XN 32GB
            6x SK Hynix / DELL HFS480G3H2X069N 480GB RAID-5 with 1 hot spare
            2x Broadcom BCM5720 Gigabit Ethernet PCIe
            2x Broadcom BCM57416 NetXtreme-E Dual-Media 10G

            iDRAC IP: 192.168.3.14

        1.2.2. Switches

        X32240
            S4128T-ON

            console IP: 192.168.3.1

        X32241
            S4128T-ON

            console IP: 192.168.3.2

2. Architecture

    2.1. Kayobe host

    Kayobe host is a bare metal server used for hosting the Kayobe VM. 

    Requirements:

    - Two separate physical network interfaces: one used for management network (connecting to Kayobe host operating system), and one for all Kayobe VM related communication. Each of the interfaces should be at least 1Gb/s.
    - Hardware virtualization enabled.
    - Ubuntu operating system installed. UTS playbooks were written and tested on Ubuntu 22.04.4 LTS, but most likely any recent version should work.
    - min. 250GB disk (where min 200GB will be used for Kayobe VM).
    - min. 12GB RAM (4GB for OS, and 8GB for Kayobe VM).
    - min. 8 CPU cores (4 for OS, and 4 for Kayobe VM).

    Network configuration (brief overview, full explanation in 3.3.):

    Interface used for accessing the server operating system:
    ACCESS: management VLAN
    TRUNK: none
    
    Interface used for Kayobe VM traffic:
    ACCESS: provisioning VLAN
    TRUNK: management VLAN, idrac VLAN


    2.2. Kayobe VM

    Kayobe VM is an Ubuntu Jammy QEMU/KVM virtual machine used for Kayobe project activities. It contains Kayobe code and configurations. Kayobe VM is used for cluster management, both from the Kayobe and Kolla perspective. Kayobe VM is automatically installed on Kayobe host with parameters specified the UTS-Playbooks. 

    2.3. Networking

        2.3.1. Physical

            Switch 1: X32240
                ethernet 1/1/1  inter switch link?
                ethernet 1/1/2  inter switch link?
                ethernet 1/1/3  S3LS211 interface 1
                ethernet 1/1/4  S3LS212 interface 1
                ethernet 1/1/5  S3LS213 interface 1 
                ethernet 1/1/6  S3LS214 interface 1 
                ethernet 1/1/7  S3LS215 (TODO: should we include that one?) interface 1
                ethernet 1/1/8  S3LS2401 interface 1         

                ethernet 1/1/13 X32229 port 3 (uplink, desc: temp_uplink)

                ethernet 1/1/19 S3LS211 iDRAC interface
                ethernet 1/1/20 S3LS212 iDRAC interface
                ethernet 1/1/21 S3LS213 iDRAC interface
                ethernet 1/1/22 S3LS214 iDRAC interface
                ethernet 1/1/23 S3LS215 iDRAC interface
                ethernet 1/1/24 S3LS2401 iDRAC interface


            Switch 2: X32241
                ethernet 1/1/1  inter switch link?
                ethernet 1/1/2  inter switch link?

                ethernet 1/1/3  S3LS211 interface 2
                ethernet 1/1/4  S3LS212 interface 2
                ethernet 1/1/5  S3LS213 interface 2
                ethernet 1/1/6  S3LS214 interface 2
                ethernet 1/1/7  S3LS215 interface 2
                ethernet 1/1/8  S3LS2401 interface 2

                ethernet 1/1/13  X32229 port 4 (uplink, desc: temp_uplink)

        2.3.2. Logical

        Cluster networking is based on VLAN separations. 

        VLANs in cluster:

        3 (server-lan-idrac) used for addressing iDrac (or any OOB/BMC) interfaces, needed for access to iDrac via browser, and IPMI.
        4 (server-lan-management) used for addressing operating systems installed on bare metal systems and Kayobe VM, 
        5 (server-lan-provision) used for temporary addressing nodes provisioned by Kayobe. Needed as DELL switches disallow usage of same VLAN as hybrid (both ACCESS and TRUNK)
        110 - 130 (tenant-vlan-110 - tenant-vlan-130) used inside OpenStack as provider networks

        Nodes that are managed by Kayobe are configured to automatically create bonded interfaces with Balance-RR mode.  

            X32240# show vlan
            Codes: * - Default VLAN, M - Management VLAN, R - Remote Port Mirroring VLANs,
                @ - Attached to Virtual Network, P - Primary, C - Community, I - Isolated
                Q: A - Access (Untagged), T - Tagged
                NUM    Status    Description                     Q Ports
            *   1      Active                                    A Eth1/1/2,1/1/9-1/1/12,1/1/14-1/1/18,1/1/25-1/1/30
                3      Active    server-lan-idrac                T Eth1/1/13
                                                                 A Eth1/1/19-1/1/24
                4      Active    server-lan-management           T Eth1/1/3-1/1/7,1/1/13
                                                                 A Eth1/1/8
                5      Active    server-lan-provision            A Eth1/1/3-1/1/7
                110    Active    tenant-vlan-110                 T Eth1/1/3-1/1/7,1/1/13
                111    Active    tenant-vlan-111                 T Eth1/1/3-1/1/7
                112    Active    tenant-vlan-112                 T Eth1/1/3-1/1/7
                113    Active    tenant-vlan-113                 T Eth1/1/3-1/1/7
                114    Active    tenant-vlan-114                 T Eth1/1/3-1/1/7
                115    Active    tenant-vlan-115                 T Eth1/1/3-1/1/7
                116    Active    tenant-vlan-116                 T Eth1/1/3-1/1/7
                117    Active    tenant-vlan-117                 T Eth1/1/3-1/1/7
                118    Active    tenant-vlan-118                 T Eth1/1/3-1/1/7
                119    Active    tenant-vlan-119                 T Eth1/1/3-1/1/7
                120    Active    tenant-vlan-120                 T Eth1/1/3-1/1/7
                121    Active    tenant-vlan-121                 T Eth1/1/3-1/1/7
                122    Active    tenant-vlan-122                 T Eth1/1/3-1/1/7
                123    Active    tenant-vlan-123                 T Eth1/1/3-1/1/7
                124    Active    tenant-vlan-124                 T Eth1/1/3-1/1/7
                125    Active    tenant-vlan-125                 T Eth1/1/3-1/1/7
                126    Active    tenant-vlan-126                 T Eth1/1/3-1/1/7
                127    Active    tenant-vlan-127                 T Eth1/1/3-1/1/7
                128    Active    tenant-vlan-128                 T Eth1/1/3-1/1/7
                129    Active    tenant-vlan-129                 T Eth1/1/3-1/1/7
                130    Active    tenant-vlan-130                 T Eth1/1/3-1/1/7

            X32241# show vlan
            Codes: * - Default VLAN, M - Management VLAN, R - Remote Port Mirroring VLANs,
                @ - Attached to Virtual Network, P - Primary, C - Community, I - Isolated
                Q: A - Access (Untagged), T - Tagged
                NUM    Status    Description                     Q Ports
            *   1      Active                                    A Eth1/1/2,1/1/9-1/1/24,1/1/26-1/1/30
                3      Active    server-lan-idrac                T Eth1/1/8,1/1/13,1/1/25
                4      Active    server-lan-management           T Eth1/1/3-1/1/8,1/1/13,1/1/25
                5      Active    server-lan-provision            A Eth1/1/3-1/1/8
                110    Active    tenant-vlan-110                 T Eth1/1/3-1/1/7,1/1/13,1/1/25
                111    Active    tenant-vlan-111                 T Eth1/1/3-1/1/7
                112    Active    tenant-vlan-112                 T Eth1/1/3-1/1/7
                113    Active    tenant-vlan-113                 T Eth1/1/3-1/1/7
                114    Active    tenant-vlan-114                 T Eth1/1/3-1/1/7
                115    Active    tenant-vlan-115                 T Eth1/1/3-1/1/7
                116    Active    tenant-vlan-116                 T Eth1/1/3-1/1/7
                117    Active    tenant-vlan-117                 T Eth1/1/3-1/1/7
                118    Active    tenant-vlan-118                 T Eth1/1/3-1/1/7
                119    Active    tenant-vlan-119                 T Eth1/1/3-1/1/7
                120    Active    tenant-vlan-120                 T Eth1/1/3-1/1/7
                121    Active    tenant-vlan-121                 T Eth1/1/3-1/1/7
                122    Active    tenant-vlan-122                 T Eth1/1/3-1/1/7
                123    Active    tenant-vlan-123                 T Eth1/1/3-1/1/7
                124    Active    tenant-vlan-124                 T Eth1/1/3-1/1/7
                125    Active    tenant-vlan-125                 T Eth1/1/3-1/1/7
                126    Active    tenant-vlan-126                 T Eth1/1/3-1/1/7
                127    Active    tenant-vlan-127                 T Eth1/1/3-1/1/7
                128    Active    tenant-vlan-128                 T Eth1/1/3-1/1/7
                129    Active    tenant-vlan-129                 T Eth1/1/3-1/1/7
                130    Active    tenant-vlan-130                 T Eth1/1/3-1/1/7


        2.3.3. Addressation

        Kayobe VM
            iDRAC network IP: 192.168.3.9
            management IP: 192.168.4.9
            provisioning network: 192.168.5.9

        S3LS2401 Kayobe Host
            iDRAC IP: 192.168.3.10
            management IP: 192.168.4.10
            provisioning network: 192.168.5.10

        S3LS211 Controller 1
            iDRAC IP: 192.168.3.11
            management IP: 192.168.4.11
            provisioning network: 192.168.5.11

        S3LS212 Controller 2 
            iDRAC IP: 192.168.3.12
            management IP: 192.168.4.12
            provisioning network: 192.168.5.12

        S3LS213 Controller 3
            iDRAC IP: 192.168.3.13
            management IP: 192.168.4.13
            provisioning network: 192.168.5.13

        S3LS214 Compute 1
            iDRAC IP: 192.168.3.14
            management IP: 192.168.4.14
            provisioning network: 192.168.5.14


3. Configuration

    3.1. Baremetal server configuration

        BIOS:
        - Ensure hardware virtualization enabled
        - Ensure PXE boot is enabled for NIC 1 Ports 1 and 2

        iDRAC: Ensure IPMI commands over network allowed

    3.2. UTS-playbooks configuration

    Servers.csv

    This file defines bare metal servers deployed by Kayobe - those will be available for Kolla roles.
    First row of this file describes fields that have to be populated if new node is added:
     IPMI - IPv4 address of an IPMI capable endpoint, in provided configuration is a iDRAC IP
     Hostname - Hostname which will be bound to given bare metal server 
     ManagementIP - IPv4 that will be configured on given server after provisioning (from management subnet 192.168.4.0/24 - VLAN 4)
     ProvisionIP - IPv4 that will be used just for provisioning purposes: from first boot with discovery image, till bond interface is created. From provisioning subnet 192.168.5.0/24 - VLAN 5
     IPMIuser - IPMI user capabable of changing power state, boot sources, boot order, and attaching virtual media to managed bare metal.
     IPMIpass - password for provided IPMIuser

    uts-playbooks/inventory.yml

    This file contains variables for the deployment environment. It will only require modifications if significant changes are made.

4. Installation process

    4.1. Prerequisites

        Steps:
            
        - Kayobe Host should fullfil "2.1. Kayobe host" requirements
        - SSH connection to Kayobe Host should be possible
        - Install pip, git, and Ansible 9.3.0:
            sudo apt install python3-pip git
            pip install ansible==9.3.0

    4.2. uts-playbooks

        Steps:
            
        - Clone configuration repository: git clone https://git/blahblah/uts-kayobe.git TODO: address
        - Rename the repo to the project name, for example: `mv uts-kayobe ait`
        - Enter uts-kayobe/uts-playbooks directory, and populate configuration files according to "3.1. uts-playbooks configuration" 

        4.2.1. Playbook provision_kayobevm.yml

            Steps:
            
            - Execute provision_kayobevm.yml playbook on Kayobe Host with: ansible-playbook -i inventory.yml provision_kayobevm.yml

            This playbook is executed on Kayobe Host. It creates and configures the Kayobe VM. It uses inventory.yml as configuration source, and automatically gathers ansible facts. 

            Ansible playbook provision_kayobevm.yml:
            - Runs set of pre-checks that are required to be fulfilled before runing any actions. 
            - Prepares Kayobe Host system as hypervisor for Kayobe VM
            - Configures Kayobe Host networking
            - Creates Kayobe VM 
            - Configures Kayobe VM and installs Kayobe project 
            - Runs Kayobe deployment related commands


        4.2.2. Playbook provision_overcloud.yml

            Steps:

            - From Kayobe Host, connect to Kayobe VM via SSH (required keys should have been populated with previous playbook)
            - Head to ait/uts-playbooks directory, execute provision_overcloud.yml playbook with: ansible-playbook -i inventory.yml provision_overcloud.yml

            This playbook is executed on Kayobe VM. It uses inventory.yml and Servers.csv file as source of data about bare metal nodes to be deployed.

            This playbook:
            - Prepares Kayobe and nodes for discovery
            - Runs nodes discovery (https://docs.openstack.org/kayobe/latest/deployment.html#discovery)
            - Provisions overcloud (https://docs.openstack.org/kayobe/latest/deployment.html#provisioning)
            - Configures overcloud host (https://docs.openstack.org/kayobe/latest/deployment.html#id5)
            - TODO: Deploys services (https://docs.openstack.org/kayobe/latest/deployment.html#id9)
            - TODO: Deploys monitoring
            - TODO: Runs post-config (https://docs.openstack.org/kayobe/latest/deployment.html#performing-post-deployment-configuration)

    4.3. Post-deployment resources

5. Procedure manuals
    5.1. New project onboarding

    5.2. Adding new node to cluster
        Steps:

        Ensure the new node is configured as described in section 3.1
        Ensure the new node has been added to
            Servers.csv
            etc/kayobe/overcloud.yml
        Run the playbook with the new node hostname paramater:
            `ansible-playbook -i inventory.yml uts-playbooks/add_node.yml -e nodename=S3LSXYZ`

        The new node will be added to inventory/overcloud and network-allocation.yml automatically, and will get the services/roles depending on where it was placed in overcloud.yml.

    5.3. Reinstalling node
