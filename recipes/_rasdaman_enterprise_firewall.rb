#
# Cookbook:: snap-base
# Recipe:: _default_firewall
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.

firewall_rule "Open port 7000 to the World" do
  port 7000
  command :allow
end
