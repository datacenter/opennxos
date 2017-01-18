class evpn_vxlan::portchannel(
$create_portchannels_list=undef,
$channelgroup_to_physicalinterface_mappings_list=undef,
){
    $create_portchannels_list.each |$portchannel|{
        evpn_vxlan::interface_portchannel{ "${portchannel['interface_name']}":
            * => $portchannel,
        }
    }
    $channelgroup_to_physicalinterface_mappings_list.each |$channelgroup_to_physicalinterface_mapping|{

        $channelgroup_id = $channelgroup_to_physicalinterface_mapping['channelgroup_id']
        $interfaces = $channelgroup_to_physicalinterface_mapping['array_of_physical_interfaces']
        $interfaces.each |$interface|{
            cisco_interface_channel_group{ $interface :
                ensure   => present,
                channel_group   => $channelgroup_id,
            }
        }

    }
}
