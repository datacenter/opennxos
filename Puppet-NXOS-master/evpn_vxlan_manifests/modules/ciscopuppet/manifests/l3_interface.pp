class ciscopuppet::l3_interface  {
  $ciscopuppet::l3_interface_cfg_data::ospf_instances.each |$area_id_name, $areaif| {
     $ospf_area_id = "${areaif[ospf_area_id]}"
     cisco_ospf { $ospf_area_id:
      ensure => present,
    }

  }
  $ciscopuppet::l3_interface_cfg_data::l3_interface_instances.each |$rtrname, $rtrintf| {
    if ($rtrname == $nodename) {
       $rtrintf.each |$interface, $value| {
         $ipaddr = "${value[ipv4_address]}"
         $mask   = "${value[mask]}"
         $area   = "${value[area]}"
         $router_ospf = "${value[router_ospf]}"

         cisco_interface { $interface :
           shutdown                     => false,
           description                  => "routed port",
           ipv4_address                 => $ipaddr,
           ipv4_netmask_length          => $mask,
         }
         $ospf_interface = "${interface} ${router_ospf}"
         cisco_interface_ospf { $ospf_interface :
            ensure                         => present,
            area                           => $area,
         }
       }
    }
  }
}
 
