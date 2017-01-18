# Overview
Manifests for the VXLAN MP BGP EVPN configuration is strucuted to include a site manifest “site.pp”, a roles file “roles.pp” and profiles file “profile.pp”.  The roles.pp defines the spine and leaf roles of the switches used in this design, and profile.pp expands the profiles applied to the respective roles.  The figure below shows the different parameterized Puppet classes used in  building the profile manifest.
![alt tag](https://github.com/datacenter/Puppet-VXLAN-CVD/blob/master/images/Profiles.jpg)

# Topology
A data center network with VxLAN and VPC configuration using Nexus 9000 series switches utilizing VxLAN with BGP control plane is depicted in the below figure.
![alt tag](https://github.com/datacenter/Puppet-VXLAN-CVD/blob/master/images/Topology.jpg)

Leaf-1, Leaf-2 are configured as VTEP1 and VTEP2 respectively. Spine-1 and Spine-2 are configured to be route reflectors. This allows all leafs to form BGP neighbor relationship. VLAN 1001, VLAN 1002 and VLAN 1003 are associated with VNI 2001001 & VNI 2001002 respectively. 

# Steps needed to replicate the topology.
The setup employs puppet master/agent architecture.

##### Puppet Master Installation and  Configuration

A VM running Ubuntu 16.04 Xenial was choosen to serve as puppet master. On this vm ,Puppet Enterprise (2016.5) was installed.Steps to install puppet enterprise on vm/node are as follow.

1. Go to [Puppet Enterprise Product Page](https://puppet.com/download-puppet-enterprise). Sign up and download puppet enterprise            installer package for your VM/node.

2. After download is complete, run the installer inside the package and follow through the prompts asked during installation.

3. If install gets successful, check whether status of all service pe-puppet are "active", before you proceed further. Use following        command to check status of services.
    ```
        systemctl status pe-puppet*
    ```

4. Set firewall rules to allow the following ports.
    ```
    sudo su
    ufw status
    ufw enable
    ufw allow 22
    ufw allow 8140
    ufw allow 4433
    ufw allow 8143
    ufw allow 8140
    ufw allow 8081
    ufw allow 4433
    ufw status
    ```
    
##### Puppet Agent Installation, Configuration, and Usage

    Puppet agent is installed on Cisco N9k series switches.
    Steps to install puppet agent on cisco N9k switches are as follow.
    ```
        Assumption made: NXOS is installed and running on all switches.
    ```

1. Login to N9K switch via ssh.

2. Enable the bash shell as follow:
    ```
    n9kswitch# configure terminal
    n9kswitch# feature bash-shell
    ```

3. Sync with ntp server 
    ```
    n9kswitch# ntp server [ntp-server-address] use-vrf management
    n9kswitch# exit
    ```

4. Run the bash shell, enter into sudo user mode and set proxy settings
    ```
    n9kswitch# run bash
    n9kswitch# sudo su -
    root@n9kswitch# ip netns exec management bash
    ```

    ###### Note: Bash shell was used in the test setup. Follow [README-agent-install.md](https://github.com/cisco/cisco-network-puppet-             module/blob/master/docs/README-agent-install.md) if you want to use other shell. 

5. Define proxy server variables to allow network access to yum.puppetlabs.com
    ```
    root@n9kswitch# export http_proxy=http://proxy.yourdomain.com:<port>
    root@n9kswitch# export https_proxy=https://proxy.yourdomain.com:<port>
    ```

6. Import the Puppet GPG keys
    ```
    root@n9kswitch# rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
    root@n9kswitch# rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-reductive
    root@n9kswitch# rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppet
    ```

7. Install the RPM
    ```
    root@n9kswitch# yum install http://yum.puppetlabs.com/puppetlabs-release-pc1-cisco-wrlinux-5.noarch.rpm
    root@n9kswitch# yum install puppet
    ```

8. Create the following softlinks and update the PATH variables
    ```
    root@n9kswitch# sudo ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet
    root@n9kswitch# sudo ln -s /opt/puppetlabs/bin/facter /usr/local/bin/facter
    root@n9kswitch# sudo ln -s /opt/puppetlabs/bin/hiera /usr/local/bin/hiera
    root@n9kswitch# sudo ln -s /opt/puppetlabs/bin/mco /usr/local/bin/mco
    root@n9kswitch# export PATH=$PATH:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/puppet/lib:/opt/puppetlabs/puppet/bin/gem
    ```

9. Configure /etc/puppetlabs/puppet/puppet.conf
    Add your Puppet Server name to the configuration file. Optional: Use certname     to specify the agent node's ID. This is only needed if hostname has not been       set.
    ```
    ...
    [main]
         server   = mypuppetmaster.mycompany.com
         certname = this_node.mycompany.com
    ...
    ```

10. Install "cisco_node_utils" gem
    ```
    root@n9kswitch# gem install cisco_node_utils
    ```

11. Start Puppet service and Run Puppet Agent
Executing the puppet agent command (with no arguments) will start the puppet agent process with the default runinterval of 30 minutes. Use the -t option to run puppet agent in test mode, which runs the agent a single time and stops.
    ```
    root@n9kswitch# service puppet start
    root@n9kswitch# puppet agent -t
    ```

12. Sign the certificate of Puppet Agent on Master node
    ```
    puppet cert list --all
    puppet cert sign "this_node.mycompany.com"
    ```
# Structuring for the manifests on the user’s server
1. Clone this repo into any directory of your choice on Puppet Master.
2. Further steps assumes you have installed Puppet Enterprise on Master correctly.
3. Copy the following folders found inside the repo you just cloned.
    ```
     $cp -rf <path_of_cloned_repo>/hieradata/nodes/   /etc/puppetlabs/code/environments/production/hieradata/
     $cp <path_of_cloned_repo>/manifests/site.pp   /etc/puppetlabs/code/environments/production/manifests/
     $cp -rf <path_of_cloned_repo>/modules/evpn_vxlan/   /etc/puppetlabs/code/environments/production/modules/
    ```
# Adding and extending a new node through Hiera
When a new node/switch is added to the topology, following steps are to be followed:

1. Create hiera file with same name as the certificate signed. This file must be placed under "/etc/puppetlabs/code/environments/production/hieradata/nodes/" as  "/etc/puppetlabs/code/environments/production/hieradata/nodes/<certname_of_new node_or_switch>.yaml".

2. Add the node definition of the newly added switch/node in "/etc/puppetlabs/code/environments/production/manifests/site.pp".
The node definition is illustarted in the following cases:

Case 1: Suppose newly added switch certname is "n9kswitch_X".

And if this switch participates in the topology as Spine , then add the following lines in site.pp file.
    ```
        ...
           node "n9kswitch_X"{
             include evpn_vxlan::role::spine_switch
           }
        ...
    ```

Case 2: Suppose newly added switch certname is "n9kswitch_Y".

And if this switch participates in the topology as Leaf , then add the following lines in site.pp file.
    ```
        ...
           node "n9kswitch_Y"{
              include evpn_vxlan::role::leaf_switch
           }
        ...
    ```
    
The details of hieradata which goes in "/etc/puppetlabs/code/environments/production/hieradata/nodes/<certname_of_new node_or_switch>.yaml" is documented well in the PuppetCVD Design Document.

