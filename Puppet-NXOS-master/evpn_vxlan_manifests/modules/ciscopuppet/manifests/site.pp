node 'spine2.cisco.com' {
  $nodename = "spine2.cisco.com"
  include role::spine_switch
}

node 'leaf1.cisco.com' {
  $nodename = "leaf1.cisco.com"
  include role::leaf_switch
}

node 'leaf2.cisco.com' {
  $nodename = "leaf2.cisco.com"
  include role::leaf_switch
}

