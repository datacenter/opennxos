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
  
class evpn_vxlan::profile::leaf_switch{
  #1. Enabling the features required
       include evpn_vxlan::enable_features::leaf
  #2. configure underlay interfaces
       include evpn_vxlan::underlay_interface
  #3. configure bgp
       include evpn_vxlan::bgp::leaf
  #4. configure pim
      include evpn_vxlan::pim::leaf
  #5. configure VTEP interface
       include evpn_vxlan::vtep_interface
  #6. configure l2vni
      include evpn_vxlan::l2vni
  #7. configure l3vni
      include evpn_vxlan::l3vni
  #8. configure vpc domain
      include evpn_vxlan::vpc_domain
  #9. configure port channel
      include evpn_vxlan::portchannel
  #10. configure peerlinks, peer keepalive link, peer_gateway SVI and peer_backup SVI
      include evpn_vxlan::peer_links
      include evpn_vxlan::peer_keepalive
      include evpn_vxlan::peer_gateway_svi
      include evpn_vxlan::peer_backup_svi
  #11. configure  ospf
      include evpn_vxlan::ospf
  #12. configure host faced interfaces
      include evpn_vxlan::host_or_server_facing_interface

  Class['evpn_vxlan::underlay_interface'] ->
  Class['evpn_vxlan::peer_gateway_svi'] ->
  Class['evpn_vxlan::peer_backup_svi'] ->
  Class['evpn_vxlan::ospf']
}

