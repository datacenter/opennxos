class evpn_vxlan::underlay_interface(
$interface_list=undef,
){

    $interface_list.each |$interface_data|{
        evpn_vxlan::interface{ "${interface_data['interface_name']}":
            * => $interface_data,
        }
    }
}
