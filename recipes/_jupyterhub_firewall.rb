#
# Cookbook:: snap-base
# Recipe:: _jupyterhub_firewall
#
# Copyright:: 2022, UAF SNAP, All Rights Reserved.


networks = ['137.229.0.0/16','199.165.64.0/18','172.16.0.0/10','10.0.0.0/8']
networks.each do |network|
  firewall_rule "JupyterHub port from #{network}" do
    port 1443
    source network
    command :allow
  end
end
