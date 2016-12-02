class ciscopuppet::l3_interface_cfg_data {
  $ospf_instances = {
    "1"=>{ospf_area_id=> "1"},
  }
  $l3_interface_instances = {
    'spine2.cisco.com' => {
       "Ethernet1/49"=>{ipv4_address=>"15.1.1.1",mask=> "24", router_ospf=>"1", area => "0.0.0.0",},
       "Ethernet1/50"=>{ipv4_address=>"14.1.1.1",mask=> "24", router_ospf=>"1", area => "0.0.0.0",},
       "Loopback0"=>{ipv4_address=>"10.10.10.1",mask=> "32", router_ospf=>"1", area => "0.0.0.0",},
    },
    'leaf1.cisco.com' => {
       "Ethernet1/52"=>{ipv4_address=>"14.1.1.2",mask=> "24", router_ospf=>"1", area => "0.0.0.0",},
       "Loopback0"=>{ipv4_address=>"1.1.1.1",mask=> "32", router_ospf=>"1", area => "0.0.0.0",},
    },
    'leaf2.cisco.com' => {
       "Ethernet1/50"=>{ipv4_address=>"15.1.1.2",mask=> "24", router_ospf=>"1", area => "0.0.0.0", },
       "Loopback0"=>{ipv4_address=>"2.2.2.2",mask=> "32", router_ospf=>"1", area => "0.0.0.0", },
    },
  }
}

