class ciscopuppet::vpc {
  cisco_command_config { "pc_depends_features" :
     command => "
       feature vpc
       feature lacp
       feature interface-vlan
     "}

  $ciscopuppet::vpc_cfg_data::vlan_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$vlan, $value| {

          $description          = "${value[description]}"
         
          cisco_vlan { $vlan :

            ensure     => present,
            state      => active,
            shutdown   => false,

          }
      }
    }
  }

  $ciscopuppet::vpc_cfg_data::vpc_domain_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$vpcdomain, $value| {
        
          $destination          = "${value[destination]}"
          $source               = "${value[source]}"
          
          $vpc_domain_details = "${vpcdomain}_details"
          cisco_command_config { $vpc_domain_details :
            command => "
              vpc domain $vpcdomain
                 peer-keepalive destination $destination source $source
                 peer-gateway
            "    
         }  
      }
    }
  }

  $ciscopuppet::vpc_cfg_data::pc_interface_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$pcnum, $value| {
          $pc_desc        = "${value[desc]}"
          $pc_allow_vlan  = "${value[allowvlan]}"
          $pc_vpc         = "${value[vpc]}"
          $pc_spanning_tree = "${value[spanning_tree]}"
          $pc_intfName    = "port-channel${pcnum}"

          #cisco_interface_portchannel {$pc_intfName:
          #  ensure => 'present',
          #}
          if ($pc_spanning_tree != "") {
	     $pcintf_spanning_tree_title = "${pc_intfName}_spanning_tree"
             cisco_command_config { $pcintf_spanning_tree_title :
             command =>"
               interface $pc_intfName
                 switchport
                 switchport mode trunk
                 spanning-tree port type $pc_spanning_tree
                 vpc $pc_vpc
                 no shutdown
             "}
          }
          if ($pc_allow_vlan != "") {
             $pcintf_allow_vlan_title = "${pc_intfName}_allow_vlan"
             cisco_command_config { $pcintf_allow_vlan_title :
             command =>"
               interface $pc_intfName
                 switchport
                 switchport mode trunk
                 switchport trunk allowed vlan $pc_allow_vlan
                 vpc $pc_vpc
                 no shutdown
             "}
          } 
        }
     }
  }
  
  $ciscopuppet::vpc_cfg_data::switchport_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$intfname, $value| {
      
          $mode          = "${value[mode]}"
          $channelgroup  = "${value[channelgroup]}"
          $allowvlan          = "${value[allowvlan]}"
          
          $swintf_details = "${intfname}_channelgroup"
          if ($allowvlan != "") {
            cisco_command_config { $swintf_details :
              command => "
                interface $intfname
                  switchport
                  switchport mode $mode
                  switchport trunk allowed vlan $allowvlan
                  channel-group $channelgroup mode active
               "
            }
          } else {
            cisco_command_config { $swintf_details :
              command => "
                interface $intfname
                  switchport
                  switchport mode $mode
                  channel-group $channelgroup 
               "
            }  
          } 
        }
     }
  }


  $ciscopuppet::vpc_cfg_data::interface_vlan_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$intfname, $value| {


          $desc          = "${value[desc]}"
          $ipaddr  = "${value[ipv4_addr]}"
          $mask          = "${value[mask]}"
 	  $vlan          = "${value[vlan]}"

          cisco_vlan { $vlan : 
            ensure     => present,
            state      => active,
            shutdown   => false,
          
	  }
          
          cisco_interface { $intfname :
           shutdown                     => false,
           description                  => $desc,
           ipv4_address                 => $ipaddr,
           ipv4_netmask_length          => $mask,
           ipv4_redirects               => false,
         }
       }
     }
  }
}

