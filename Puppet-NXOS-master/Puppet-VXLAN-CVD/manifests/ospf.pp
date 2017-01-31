class evpn_vxlan::ospf(
$process_id="1",
$area="0.0.0.0",
$ospf_interfaces=undef,
)
{
    cisco_ospf{ $process_id:
           ensure => present,
    }

    $ospf_interfaces.each |$ospf_interface|{
        cisco_interface_ospf{ "${ospf_interface['interface_name']} ${process_id}":
            ensure => present,
            area  => $area,
        }
    }
}
