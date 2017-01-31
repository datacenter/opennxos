node 'spine_1'{
   include evpn_vxlan::role::spine_switch
}

node 'spine_2'{
   include evpn_vxlan::role::spine_switch
}

node 'leaf_1'{
   include evpn_vxlan::role::leaf_switch
}

node 'leaf_2'{
   include evpn_vxlan::role::leaf_switch
}
