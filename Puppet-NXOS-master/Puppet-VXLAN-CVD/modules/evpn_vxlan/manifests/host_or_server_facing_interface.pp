class evpn_vxlan::host_or_server_facing_interface(
$interface_list=undef,){

    #require port-channels to be created if the interface is part of any channel-group
    $interface_list.each |$interface|{

        cisco_interface{ "${interface['name']}":
            * => $interface,
        }
    }

}

