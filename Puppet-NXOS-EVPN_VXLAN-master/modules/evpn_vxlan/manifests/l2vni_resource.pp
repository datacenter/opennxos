define evpn_vxlan::l2vni_resource(
$vtep_interface_name,
$anycast_gateway_mac=undef,
$vlan_interfaces=undef,
){
    cisco_overlay_global{'default':
        anycast_gateway_mac=> $anycast_gateway_mac,
    }

    $vlan_interfaces.each |$vlan_interface|{

        $vlan_id     = $vlan_interface['vlan']
        $mapped_vni  = $vlan_interface['mapped_vni']
        $vrf         = $vlan_interface['vrf_membership']
        $mcast_group = $vlan_interface['mcast_group']
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
            ipv4_address            => $vlan_interface['ipv4_address'],
            ipv4_netmask_length     => $vlan_interface['ipv4_netmask_length'],
            vrf                     => $vrf,
            fabric_forwarding_anycast_gateway => "true",
            ipv6_address            => $vlan_interface['ipv6_address'],
        }

        #evpn related configuration
        cisco_evpn_vni { "${mapped_vni}":
            ensure                        => present,
            route_distinguisher           => 'auto',
            route_target_import           => 'auto',
            route_target_export           => 'auto',
        }

        #vtep related configuration
        cisco_vxlan_vtep_vni { "${vtep_interface_name} ${mapped_vni}":
                ensure              => present,
                multicast_group     => $mcast_group,
                suppress_arp        => true,
        } 
    }
}

