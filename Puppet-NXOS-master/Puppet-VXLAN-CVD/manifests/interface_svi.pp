define evpn_vxlan::interface_svi(
$interface_name="vlan1",
$description="default",
$ipv4_address="default",
$ipv4_netmask_length="default",
$ipv4_pim_sparse_mode="default",
$ipv4_address_secondary="default",
$ipv4_netmask_length_secondary="default",
$ipv6_address=undef,
$vrf="default",
$fabric_forwarding_anycast_gateway="default",
){

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
        switchport_mode             => "disabled",
    }

    #check if ipv6 paramter is set, if set then configure the ipv6 for the interface
    if ($ipv6_address!=undef){
       $command_to_give = "interface ${interface_name} \nipv6 address ${ipv6_address}"
       notice("getting inside ipv6 configuration")

       cisco_command_config{ "${interface_name}" :
            command => "${command_to_give}"
       }

       notice("getting outside ipv6 configuration")
    }

}
