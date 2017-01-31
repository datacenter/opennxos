class evpn_vxlan::enable_features::spine{
   cisco_command_config{ "Enable_req_features_for_configuration_on_spine_switch":
        command=> "feature pim
            feature bgp
            feature ospf
            nv overlay evpn",
    }
}
