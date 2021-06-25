#
# Cookbook:: snap-base
# Recipe:: nrpe
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'nagios-plugins-all'
package 'nrpe'

sudo 'nrpe' do
  user 'nrpe'
  runas 'root'
  commands ["/usr/bin/wbinfo","/sbin/sfdisk","/usr/sbin/smartctl"]
  nopasswd true
end

cookbook_file '/etc/nagios/nrpe.cfg' do
  source 'nrpe.cfg'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

service 'nrpe' do
  supports :status => true
  action [:enable, :start]
end
