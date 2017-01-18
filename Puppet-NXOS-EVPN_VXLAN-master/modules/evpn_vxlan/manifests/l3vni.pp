class evpn_vxlan::l3vni(
$vtep_interface_name="nve1",
$vlan_interfaces=undef,
){

    evpn_vxlan::l3vni_resource{"Configure l3vni":
        vtep_interface_name => $vtep_interface_name,
        vlan_interfaces     => $vlan_interfaces,
    }
}
