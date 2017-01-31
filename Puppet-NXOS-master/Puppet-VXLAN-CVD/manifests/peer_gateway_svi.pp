class evpn_vxlan::peer_gateway_svi(
$vlan_id=undef,
$description="default",
$ipv4_address="default",
$ipv4_netmask_length="default",
$ipv4_pim_sparse_mode="default",){

    #ensure the vlan for peer_gateway_SVI is created/present
    cisco_vlan { $vlan_id:
        ensure         => present,
        shutdown       => false,
        state          => 'active',
    }

    #create SVI for peer_gateway
    cisco_interface{"vlan${vlan_id}":
        ensure               => present,
        description          => $description,
        ipv4_address         => $ipv4_address,
        ipv4_netmask_length  => $ipv4_netmask_length,
        ipv4_pim_sparse_mode => $ipv4_pim_sparse_mode,
        shutdown             => false,
    }

}
