class evpn_vxlan::profile::spine_switch{

  #1. Enabling the features required
  include evpn_vxlan::enable_features::spine
  #2. configure underlay interfaces
  include evpn_vxlan::underlay_interface
  #3. configure  ospf
  include evpn_vxlan::ospf
  #4. configure bgp
  include evpn_vxlan::bgp::spine
  #5. configure pim
  include evpn_vxlan::pim::spine

  Class['evpn_vxlan::underlay_interface'] ->
  Class['evpn_vxlan::ospf']
}
