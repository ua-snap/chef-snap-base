#
# Cookbook:: snap-base
# Recipe:: _rstudio_firewall
#
# Copyright:: 2020, The Authors, All Rights Reserved.

networks = ['137.229.0.0/16','199.165.64.0/18','172.16.0.0/10','10.0.0.0/8']
networks.each do |network|
  firewall_rule "RStudio port open to #{network}" do
    port 8787
    command :allow
  end
end
