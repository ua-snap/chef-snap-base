#
# Cookbook:: snap-base
# Recipe:: _dot_api_firewall
#
# Copyright:: 2023, The Authors, All Rights Reserved.

firewall_rule "Open port 3000 to the World" do
  port 3000
  command :allow
end
