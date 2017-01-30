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
