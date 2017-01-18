class evpn_vxlan::enable_features{
}

class evpn_vxlan::enable_features::spine{
   cisco_command_config{ "Enable_req_features_for_configuration_on_spine_switch":
        command=> "feature pim
            feature bgp
            feature ospf
            nv overlay evpn",
    }
}

class evpn_vxlan::enable_features::leaf{
   cisco_command_config{ "Enable_req_features_for_configuration_on_leaf_switch":
        command=> "feature pim
            feature bgp
            feature ospf
            nv overlay evpn
            feature interface-vlan
            feature fabric forwarding
            feature vn-segment-vlan-based
            feature nv overlay
            feature vpc
            feature lacp",
    }
}
