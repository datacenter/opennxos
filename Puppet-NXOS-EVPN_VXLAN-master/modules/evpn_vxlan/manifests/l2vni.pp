class evpn_vxlan::l2vni(
$vtep_interface_name="nve1",
$anycast_gateway_mac=undef,
$vlan_interfaces=undef,
){

    evpn_vxlan::l2vni_resource{"Configure l2vni":
        vtep_interface_name => $vtep_interface_name,
        anycast_gateway_mac => $anycast_gateway_mac,
        vlan_interfaces     => $vlan_interfaces,
    }
}
