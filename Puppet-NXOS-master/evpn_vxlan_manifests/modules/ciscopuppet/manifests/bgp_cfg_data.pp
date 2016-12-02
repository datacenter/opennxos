class ciscopuppet::bgp_cfg_data {
  $bgp_instances = {
    'spine2.cisco.com' => {
       65000=>{ neighbor1=>"1.1.1.1", asn1=>65000, update_source_1=>"loopback0", neighbor2=> "2.2.2.2", asn2 => 65000, update_source_2=>"loopback0",route_reflector => "true",},
    },
    'leaf1.cisco.com' => {
       65000=>{ neighbor1=>"10.10.10.1", asn1=>65000, update_source_1=>"loopback0",route_reflector => "false",},
    },
    'leaf2.cisco.com' => {
       65000=>{ neighbor1=>"10.10.10.1", asn1=>65000, update_source_1=>"loopback0",route_reflector => "false",},
    },
  }
}

