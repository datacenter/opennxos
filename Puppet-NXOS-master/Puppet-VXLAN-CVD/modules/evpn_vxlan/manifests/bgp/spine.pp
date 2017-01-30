class evpn_vxlan::bgp::spine(
$as_number = '',
$router_id='default',
$set_as_leaf_neighbor=undef,
){

    cisco_bgp { $as_number:
        ensure => present,
        router_id => $router_id,
    }

    Cisco_bgp_neighbor <<| tag=="leaf_neighbor" |>>
    Cisco_bgp_neighbor_af <<| tag=="leaf_neighbor" |>>
    if ( $set_as_leaf_neighbor['route_reflector_client'] ){


        @@cisco_bgp_neighbor { "${as_number} default ${set_as_leaf_neighbor['neighbor_address']}":
            ensure                 => present,
            asn                    => $as_number,
            vrf                    => $set_as_leaf_neighbor['vrf'],
            remote_as              => $as_number,
            update_source          => $set_as_leaf_neighbor['update_source'],
            tag                    => "spine_neighbor",
        }

        @@cisco_bgp_neighbor_af { "${as_number} default ${set_as_leaf_neighbor['neighbor_address']} ${set_as_leaf_neighbor['address_family']['afi']} ${set_as_leaf_neighbor['address_family']['safi']}":
            ensure                 => "present",
            asn                    => $as_number,
            vrf                    => $set_as_leaf_neighbor['vrf'],
            neighbor               => $set_as_leaf_neighbor['neighbor_address'],
            afi                    => $set_as_leaf_neighbor['address_family']['afi'],
            safi                   => $set_as_leaf_neighbor['address_family']['safi'],
            send_community         => $set_as_leaf_neighbor['send_community'],
            route_reflector_client => $set_as_leaf_neighbor['route_reflector_client'],
            tag                    => "spine_neighbor",
        }
    }
}
