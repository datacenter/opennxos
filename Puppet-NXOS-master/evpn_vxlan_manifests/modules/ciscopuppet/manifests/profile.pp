#
#Sample Profiles
#
class ciscopuppet::profile::base {
   include ciscopuppet::install   
}

class ciscopuppet::profile::l3_interface_cfg {
  include ciscopuppet::l3_interface_cfg_data
  include ciscopuppet::l3_interface
} 

class ciscopuppet::profile::vlan_cfg {
   include ciscopuppet::vlan_cfg_data
   include ciscopuppet::vlan
}

class ciscopuppet::profile::evpn_cfg {
   include ciscopuppet::evpn_cfg_data
   include ciscopuppet::evpn
}

class ciscopuppet::profile::bgp_cfg {
   include ciscopuppet::bgp_cfg_data
   include ciscopuppet::bgp
}
