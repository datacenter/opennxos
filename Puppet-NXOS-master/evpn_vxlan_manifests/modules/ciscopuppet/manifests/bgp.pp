class ciscopuppet::bgp  {
  cisco_command_config { "BGP_EVPN_features" :
              command => "
                nv overlay evpn
                feature vn-segment-vlan-based
                feature nv overlay
               "
       }

  $ciscopuppet::bgp_cfg_data::bgp_instances.each |$rtrname, $rtrpid| {
    if ($rtrname == $nodename) {
      $rtrpid.each |$pid, $value| {
        $inst = $pid
        $asnum1 = $value[asn1]
        $neighbor1 = "${value[neighbor1]}"
        $asnum2 = $value[asn2]
        $neighbor2 = "${value[neighbor2]}"
        $rr = "${value[route_reflector]}"
	$update_source_1 = "${value[update_source_1]}"
        $update_source_2 = "${value[update_source_2]}"

       #Create BGP instances
       cisco_bgp { "${inst}" :
         ensure => present,
         router_id => $routerid,
       }
       
       cisco_command_config { "bgp_${inst}" :
              command => "
                router bgp $inst
                  address-family l2vpn evpn
               "
       }
       cisco_bgp_af { "${inst}_v4" :
           ensure => present,
           asn => $inst,
           afi => 'ipv4',
           safi => 'unicast',
       }     


#       cisco_command_config { "bgp_${inst}_evpn" :
#              command => "
#                router bgp $inst
#                  neighbor $neighbor1 
#                    address-family l2vpn evpn
#                      send-community both
#               "
#       }
#       cisco_bgp_af { "${inst}_evpn" :
#           ensure => present,
#           asn => $inst,
#           afi => 'l2vpn',
#           safi => 'evpn',
#       } 

       cisco_bgp_neighbor { "${inst}":
         ensure                    => present,
         asn                       => $inst,
         neighbor                  => $neighbor1,
         remote_as                 => $asnum1,
         update_source             => $update_source_1,
       }

       cisco_bgp_neighbor_af { "${inst}_v4_${neighbor1}":
         ensure                                 => present,
         asn                                    => $inst,
         neighbor                               => $neighbor1,
         afi                                    => 'ipv4',
         safi                                   => 'unicast',
         route_reflector_client                 => $rr,
         send_community                         => 'both',
       }
       
       cisco_bgp_neighbor_af { "${inst}_evpn_${neighbor1}":
         ensure                                 => present,
         asn                                    => $inst,
         neighbor                               => $neighbor1,
         afi                                    => 'l2vpn',
         safi                                   => 'evpn',
         route_reflector_client                 => $rr,
         send_community                         => 'both',
       } 

#       cisco_command_config { "bgp_${inst}_evpn" :
#              command => " 
#                router bgp $inst
#                  neighbor $neighbor1 remote-as $inst
#                    address-family l2vpn evpn
#                      send-community both
#              "
#       }


       if ($value[neighbor2]) {
         cisco_bgp_neighbor { "${inst}_neighbor2":
           ensure                    => present,
           asn                       => $inst,
           neighbor                  => $neighbor2,
           remote_as                 => $asnum2,
           update_source             => $update_source_2,
         }
         cisco_bgp_neighbor_af { "${inst}_v4_${neighbor2}":
           ensure                                 => present,
           asn                                    => $inst,
           neighbor                               => $neighbor2,
           afi                                    => 'ipv4',
           safi                                   => 'unicast',
           route_reflector_client                 => $rr,
           send_community                         => 'both',
         } 
       
         cisco_bgp_neighbor_af { "${inst}_evpn_${neighbor2}":
           ensure                                 => present,
           asn                                    => $inst,
           neighbor                               => $neighbor2,
           afi                                    => 'l2vpn',
           safi                                   => 'evpn',
           route_reflector_client                 => $rr,
           send_community                         => 'both',
         }
       }
      }
    }
  }
}
