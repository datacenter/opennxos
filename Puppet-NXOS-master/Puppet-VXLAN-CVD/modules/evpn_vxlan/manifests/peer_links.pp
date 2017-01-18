class evpn_vxlan::peer_links(
$interface_list){

    #configuring peerkeepalive interfaces
    $interface_list.each |$interface_data|{
        cisco_interface{ "${interface_data['interface_name']}":
            ensure       => present,
            interface    => $interface_data['interface_name'],
            shutdown     => false,
            description  => $interface_data['description'],
        }
    }
}
