class ciscopuppet::evpn  {
  $ciscopuppet::evpn_cfg_data::evpn_instances.each |$rtrname, $rtrpid| {
    if ($rtrname == $nodename) {
      $rtrpid.each |$vni_name, $vni_value| { 
        $rd = "${vni_value[route_dist]}"
        $rt_both = "${vni_value[route_target_both]}"
        cisco_evpn_vni {$vni_name :
          ensure                    => present,
          route_distinguisher       => $rd,
          route_target_both         => $rt_both,
        }
      }
    }
  }

  $ciscopuppet::evpn_cfg_data::nve_instances.each |$rtrname, $rtrpid| {
     if ($rtrname == $nodename) {
       $rtrpid.each |$intf_name, $intf_value| {
       $desc = "${intf_value[description]}"
       $source_interface = "${intf_value[source_interface]}"
       $hr_proto ="${intf_value[host_reachability]}"
       cisco_vxlan_vtep { $intf_name:
        ensure                          => present,
        description                     => $desc,
#        host_reachability               => $hr_proto,
        shutdown                        => false,
        source_interface                => $source_interface,
       }

      cisco_command_config { "evpn_${inst}_bgp" :
              command => "
                interface $intf_name
                  host-reachability protocol bgp
               "
       }
      $nve_vtep_vni = "${intf_name} ${intf_value[vni]}"
      $ingress_rep = "${intf_value[ig_proto]}"
      cisco_vxlan_vtep_vni { $nve_vtep_vni:
        ensure              => present,
        ingress_replication => $ingress_rep,
        }
      }
    }
  }
}

