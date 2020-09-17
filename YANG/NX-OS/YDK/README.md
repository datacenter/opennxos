The switches need to run NX-OS 7.0(3)I7(4) or later.

Edit the switch management IP or DNS and the credentials to match your device in the Python scripts:
```
ncc = NetconfServiceProvider(address='MY_SWITCH',
                             username='MY_USER', password='MY_PASSWORD')
```

Make sure NETCONF is enabled on the switch:
```
switch# conf t
Enter configuration commands, one per line. End with CNTL/Z.
switch(config)# feature netconf
```
