#
# Cookbook:: snap-base
# Recipe:: _web_firewall
#
# Copyright:: 2018, The Authors, All Rights Reserved.

firewall_rule 'Tomcat HTTP port open to the world' do
  port 8080
  command :allow
end

firewall_rule 'Tomcat HTTPS port open to the world' do
  port 8443
  command :allow
end
