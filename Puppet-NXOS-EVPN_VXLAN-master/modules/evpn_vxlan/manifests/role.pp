class evpn_vxlan::role{
}

class evpn_vxlan::role::spine_switch{
    include evpn_vxlan::profile::spine_switch
}

class evpn_vxlan::role::leaf_switch{
    include evpn_vxlan::profile::leaf_switch
}

