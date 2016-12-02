#Configuring Interface eth1/1
     cisco_interface { "Ethernet1/1" :
        shutdown            => true,
        switchport_mode     => disabled,
        description         => 'managed by puppet',
        ipv4_address        => '1.1.43.43',
        ipv4_netmask_length => 24,
      }
#Configuring interface eth1/2
     cisco_interface { "Ethernet1/2" :
        description => 'default',
        shutdown    => 'default',
        access_vlan => 'default',
        switchport_mode => access,
     }
#Configuring interface
     cisco_interface { "Vlan22" :
        svi_autostate => false,
        svi_management => true,
     }
