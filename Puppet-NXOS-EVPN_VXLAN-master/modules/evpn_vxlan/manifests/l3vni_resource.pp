define evpn_vxlan::l3vni_resource(
$vtep_interface_name,
$vlan_interfaces=undef,
){

    $vlan_interfaces.each |$vlan_interface|{

        $vlan_id     = $vlan_interface['vlan']
        $mapped_vni  = $vlan_interface['mapped_vni']
        $vrf         = $vlan_interface['vrf_membership']
        $as_number   = $vlan_interface['as_number']

        cisco_vrf{$vrf:
            ensure              => present,
            vni                 => $mapped_vni,
            route_distinguisher => "auto"
        }

        cisco_vrf_af{ "${vrf} ipv4 unicast":
            ensure                      =>  present,
            route_target_both_auto      =>  true,
            route_target_both_auto_evpn =>  true,
        }


        cisco_vrf_af{ "${vrf} ipv6 unicast":
            ensure                      =>  present,
            route_target_both_auto      =>  true,
            route_target_both_auto_evpn =>  true,
        }

        #vlan creation
        cisco_vlan { $vlan_id:
            ensure         => present,
            mapped_vni     => $mapped_vni,
            shutdown       => false,
            state          => 'active',
        }
        #configuring svi
        evpn_vxlan::interface_svi{ "vlan${vlan_id}":
            interface_name          => "vlan${vlan_id}",
            description             => "L3 vni vlan",
            vrf                     => $vrf,

        }
        #configuring cisco_bgp_af under l3vni
        cisco_bgp_af { "${as_number} ${vrf} ipv4 unicast":
            ensure                  => "present",
            advertise_l2vpn_evpn    => 'true',
        }
        #vtep related configuration
        cisco_vxlan_vtep_vni { "${vtep_interface_name} ${mapped_vni}":
            ensure              => present, 
            assoc_vrf           =>  true,
        }

    }
}
