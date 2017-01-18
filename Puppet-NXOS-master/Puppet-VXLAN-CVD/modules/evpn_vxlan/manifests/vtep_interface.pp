class evpn_vxlan::vtep_interface(
$interface_name,
$description="default",
$source_interface="default",
){

    cisco_vxlan_vtep { "${interface_name}" :
        ensure                          => present,
        description                     => $description,
        source_interface                => $source_interface,
        shutdown                        => false,
    }

    cisco_command_config { "interface_name_${interface_name}":
        command =>"interface ${interface_name}
          host-reachability protocol bgp
        "
    }
}
