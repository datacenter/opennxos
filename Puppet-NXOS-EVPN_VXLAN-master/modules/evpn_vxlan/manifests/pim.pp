class evpn_vxlan::pim::leaf(
$rp_address=undef,
$rp_group=undef,
$ssm_group='none',
){
    if ( $rp_address !=undef){
        cisco_pim_rp_address { 'ipv4' :
            ensure          => present,
            vrf             => 'default',
            rp_addr         => $rp_address,
        }
    }

    if ( $rp_address!= undef and $rp_group!=undef ){
        cisco_pim_grouplist { 'ipv4' :
            ensure          => present,
            vrf             => 'default',
            rp_addr         => $rp_address,
            group           => $rp_group,
        }
    }

    if ( $ssm_group !='none' ){
        cisco_pim { 'ipv4' :
            ensure         => present,
            vrf            => 'default',
            ssm_range      =>  $ssm_group,
        }
    }
}

class evpn_vxlan::pim::spine(
$rp_address=undef,
$rp_group=undef,
$rp_candidate_interface=undef,
$ssm_group='none',
$anycast_rp_peer_address_list=undef,
){

    if ( $rp_address !=undef){
        cisco_pim_rp_address { 'ipv4' :
            ensure          => present,
            vrf             => 'default',
            rp_addr         => $rp_address,
        }
    }

    if ( $rp_address!= undef and $rp_group!=undef ){
        cisco_pim_grouplist { 'ipv4' :
            ensure          => present,
            vrf             => 'default',
            rp_addr         => $rp_address,
            group           => $rp_group,
        }
    }

    if ( $ssm_group !='none' ){
        cisco_pim { 'ipv4' :
            ensure         => present,
            vrf            => 'default',
            ssm_range      =>  $ssm_group,
        }
    }

    if ( $rp_candidate_interface != undef){
        cisco_command_config { "configure_ip_pim_rp_candidate" :
            command => "ip pim rp-candidate ${rp_candidate_interface} group-list ${rp_group}"
        }
    }

    if ($anycast_rp_peer_address_list != undef){
        $anycast_rp_peer_address_list.each |$anycast_rp_peer_address|{

            cisco_command_config {"pim_anycast_rp_config_${anycast_rp_peer_address}" :
               command => "ip pim anycast-rp ${rp_address} ${anycast_rp_peer_address}"
            }
        }
    }

}

