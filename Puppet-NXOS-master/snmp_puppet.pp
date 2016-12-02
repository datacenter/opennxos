# Configure snmp community

class snmp_community_test {

  cisco_snmp_community { "test":
    ensure => present,
    group  => "network-operator",
    acl    => "aclname",
  }

}

class { 'snmp_community_test': }