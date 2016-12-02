#Configuring vlan
     cisco_vlan { "220":
        ensure => present,
        vlan_name => 'newtest',
        shutdown => 'true',
        state => 'active',
     }
