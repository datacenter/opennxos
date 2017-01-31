define evpn_vxlan::interface(
$interface_name="loopback0",
$description="default",
$ipv4_address="default",
$ipv4_netmask_length="default",
$ipv4_pim_sparse_mode="default",
$switchport_mode="disabled",
$ipv4_address_secondary="default",
$ipv4_netmask_length_secondary="default",
$ipv6_address=undef,
$vrf="default",
$fabric_forwarding_anycast_gateway="default",
$vpc_id=undef,
$vpc_peer_link="false",
$switchport_trunk_native_vlan="default",
$switchport_trunk_allowed_vlan="default",
){
    #check if ipv6 paramter is set, if set then configure the ipv6 for the interface
    if ($ipv6_address!=undef){
       $command_to_give = "interface ${interface_name} \nipv6 address ${ipv6_address}"
       cisco_command_config{ "${interface_name}" :
            command => "${command_to_give}"
       }
    }
  
    cisco_interface{ "${interface_name}":
        ensure                       => "present",
        shutdown                     => "false",
        description                  => $description,
        ipv4_address                 => $ipv4_address,
        ipv4_netmask_length          => $ipv4_netmask_length,
        ipv4_pim_sparse_mode         => $ipv4_pim_sparse_mode,
        ipv4_address_secondary       => $ipv4_address_secondary,
        ipv4_netmask_length_secondary=> $ipv4_netmask_length_secondary,
        vrf                          => $vrf,
        fabric_forwarding_anycast_gateway => $fabric_forwarding_anycast_gateway,
        vpc_id                       => $vpc_id,
        vpc_peer_link                => $vpc_peer_link,
         switchport_mode             => $switchport_mode,
        switchport_trunk_native_vlan => $switchport_trunk_native_vlan,
        switchport_trunk_allowed_vlan=> $switchport_trunk_allowed_vlan,
    }

}

