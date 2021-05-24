#
# Cookbook:: snap-base
# Recipe:: _default_firewall
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.


firewall_rule "Open port 80 to the World" do
  port 80
  command :allow
end

firewall_rule "Open port 443 to the World" do
  port 443
  command :allow
end
