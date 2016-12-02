class ciscopuppet::vpc_cfg_data {
  $pc_interface_details = {
    'leaf1.cisco.com' => {
      20=>{ desc=>"Interface Vlan", allowvlan=>"", spanning_tree=>"network", vpc=>"peer-link"},
      100=>{ desc=>"Interface Vlan", allowvlan=>"1-100", spanning_tree=>"", vpc=>"10"},
      101=>{ desc=>"Interface Vlan", allowvlan=>"1-100", spanning_tree=>"", vpc=>"11"},
    },
    'leaf2.cisco.com' => {
      20=>{ desc=>"Interface Vlan", allowvlan=>"", spanning_tree=>"network", vpc=>"peer-link"},
      100=>{ desc=>"Interface Vlan", allowvlan=>"1-100", spanning_tree=>"", vpc=>"10"},
      101=>{ desc=>"Interface Vlan", allowvlan=>"1-100", spanning_tree=>"", vpc=>"11"},
    },
  }
  
  $switchport_details = {
    'leaf1.cisco.com' => {
      "Ethernet1/13" => { mode=> "trunk", allowvlan => "", channelgroup => "20", },
      "Ethernet1/14" => { mode=> "trunk", allowvlan => "", channelgroup => "20", },
      "Ethernet1/31" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "100", },
      "Ethernet1/32" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "101", },
    },
  
    'leaf2.cisco.com' => {
      "Ethernet1/13" => { mode=> "trunk", allowvlan => "", channelgroup => "20", },
      "Ethernet1/14" => { mode=> "trunk", allowvlan => "", channelgroup => "20", },
      "Ethernet1/31" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "100", },
      "Ethernet1/32" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "101", },
    },

    'leaf3.cisco.com' => {
      "Ethernet1/31" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "100", },
      "Ethernet1/32" => { mode=> "trunk", allowvlan => "1-100", channelgroup => "101", },
    },
  }

  $vlan_details = {
    'leaf1.cisco.com' => {
      "10" => { description => "VPC Vlan",},
      "11" => { description => "VPC Vlan",},
    },
    'leaf2.cisco.com' => {
      "10" => { description => "VPC Vlan",},
      "11" => { description => "VPC Vlan",},
    },
    'leaf3.cisco.com' => {
      "10" => { description => "VPC Vlan",},
      "11" => { description => "VPC Vlan",},
    },
  }
 
  $interface_vlan_details = {
    'leaf1.cisco.com' => {
      "Vlan20" => { ipv4_addr => "192.10.10.91", mask =>"24", vlan=> "${external_vlan}",},
    },
    'leaf2.cisco.com' => {
      "Vlan20" => { ipv4_addr => "192.10.10.90", mask =>"24", vlan=> "${external_vlan}",},
    },
    'leaf3.cisco.com' => {
      "Vlan20" => { ipv4_addr => "200.10.10.101", mask =>"24", vlan=> "${external_vlan}",},
    },
  }

  $vpc_domain_details = {
    'leaf1.cisco.com' => {
      "10" => { destination => "173.36.219.68", source =>"173.36.219.67",},
    },

    'leaf2.cisco.com' => {
      "10" => { destination => "173.36.219.67", source =>"173.36.219.68",},
    },
  }
}

