#
# Cookbook:: snap-base
# Recipe:: _default_firewall
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.

include_recipe 'firewall::default'

firewall 'default'

networks = ['137.229.0.0/16','199.165.64.0/18','172.16.0.0/10','10.0.0.0/8']
networks.each do |network|
  firewall_rule "SSH from #{network}" do
    port 22
    source network
    command :allow
  end
  firewall_rule "ICMP from #{network}" do
    protocol :icmp
    source network
    command :allow
  end
end
