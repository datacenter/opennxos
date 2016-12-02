class ciscopuppet::evpn_cfg_data {
  $evpn_instances = {
    'leaf1.cisco.com' => {
       "10010"=>{route_dist=>"auto",route_target_both=> "auto", },
    },
    'leaf2.cisco.com' => {
       "10010"=>{route_dist=>"auto",route_target_both=> "auto", },
    },
  }

  $nve_instances = {
    'leaf1.cisco.com' => {
       "nve1"=>{description=>"nve_interface", source_interface=>"loopback0", host_reachability=>"bgp", vni=>"10010", ig_proto => "bgp", },
    },
    'leaf2.cisco.com' => {
       "nve1"=>{description=>"nve_interface", source_interface=>"loopback0", host_reachability=>"bgp", vni=>"10010", ig_proto => "bgp", },
    },
  }
}
