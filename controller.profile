export SB=$(docker exec openvswitch_vswitchd ovs-vsctl get open . external_ids:ovn-remote | sed -e 's/\"//g')
export NB=$(docker exec openvswitch_vswitchd ovs-vsctl get open . external_ids:ovn-remote | sed -e 's/\"//g' | sed -e 's/6642/6641/g')
alias ovs-vsctl='docker exec openvswitch_vswitchd ovs-vsctl'
alias ovs-ofctl='docker exec openvswitch_vswitchd ovs-ofctl'
alias ovs-appctl='docker exec openvswitch_vswitchd ovs-appctl'
alias ovs-dpctl='docker exec openvswitch_vswitchd ovs-dpctl'
alias ovn-sbctl='docker exec ovn_controller ovn-sbctl --db=$SB'
alias ovn-nbctl='docker exec ovn_controller ovn-nbctl --db=$NB'
alias ovn-trace='docker exec ovn_controller ovn-trace --db=$SB'