class ciscopuppet::vlan {

  $ciscopuppet::vlan_cfg_data::vlan_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$vlan, $value| {

          $description          = "${value[description]}"
          $mapped_vni          = "${value[mapped_vni]}"
         
          cisco_vlan { $vlan :

            ensure     => present,
            state      => active,
            shutdown   => false,
            mapped_vni => $mapped_vni,
	    vlan_name  => $description,

          }
      }
    }
  }

  $ciscopuppet::vlan_cfg_data::switchport_details.each |$rtrname,$rtrvalue| {
     if ($rtrname == $nodename) {
        $rtrvalue.each |$intfname, $value| {
      
          $mode          = "${value[mode]}"
          $allowvlan          = "${value[allowvlan]}"
          
          $swintf_details = "${intfname}_vlan"
            cisco_command_config { $swintf_details :
              command => "
                interface $intfname
                  switchport
                  switchport mode $mode
                  switchport trunk allowed vlan $allowvlan
               "
           } 
        }
     }
  }
}

