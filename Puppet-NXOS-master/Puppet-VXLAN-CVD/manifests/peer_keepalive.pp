class evpn_vxlan::peer_keepalive(
$interface_list=undef,){

    #configuring peerkeepalive interfaces
    $interface_list.each |$interface_data|{
        evpn_vxlan::interface{ "${interface_data['interface_name']}":
            * => $interface_data,
        }
    }
	
}
