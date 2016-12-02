#Configure tacacs server
 cisco_tacacs_server {"default":
    ensure              => present,
    timeout             => 10,
    directed_request    => true,
    deadtime            => 20,
    encryption_type     => clear,
    encryption_password => 'test123',
    source_interface    => 'Ethernet1/2',
 }
