#
# Cookbook:: snap-base
# Recipe:: _loki_web_firewall
#
# Copyright:: 2025, The Authors, All Rights Reserved.

firewall_rule "Loki port open to Apollo" do
    port 3100
    source '137.229.113.241'
    command :allow
end