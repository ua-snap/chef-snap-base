#
# Cookbook:: snap-base
# Recipe:: _prometheus_web_firewall
#
# Copyright:: 2025, The Authors, All Rights Reserved.

firewall_rule "Prometheus port open to Apollo" do
    port 9090
    source '137.229.113.241'
    command :allow
end