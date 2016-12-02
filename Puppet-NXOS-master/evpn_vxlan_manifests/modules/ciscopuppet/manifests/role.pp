#
# Sample SFDC switch/router roles
#

#
# Base Role
#
class ciscopuppet::role {
  include ciscopuppet::profile::base
}

#
# Spine Switch Role 
#
class ciscopuppet::role::spine_switch inherits ciscopuppet::role {
 include ciscopuppet::profile::l3_interface_cfg
 include ciscopuppet::profile::bgp_cfg 
}

#
# Leaf Switch Role 
#
class ciscopuppet::role::leaf_switch inherits ciscopuppet::role {
  include ciscopuppet::profile::l3_interface_cfg
  include ciscopuppet::profile::vlan_cfg
  include ciscopuppet::profile::evpn_cfg
  include ciscopuppet::profile::bgp_cfg
}
