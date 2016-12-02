class ciscopuppet::vlan_cfg_data {
  
  $switchport_details = {
    'leaf1.cisco.com' => {
      "Ethernet1/13" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/14" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/31" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/32" => { mode=> "trunk", allowvlan => "1-10", },
    },
  
    'leaf2.cisco.com' => {
      "Ethernet1/13" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/14" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/31" => { mode=> "trunk", allowvlan => "1-10", },
      "Ethernet1/32" => { mode=> "trunk", allowvlan => "1-10", },
    },

  }

  $vlan_details = {
    'leaf1.cisco.com' => {
      "10" => { description => "video", mapped_vni => 10010},
    },
    'leaf2.cisco.com' => {
      "10" => { description => "video", mapped_vni => 10010,},
    },
  }
 
}

