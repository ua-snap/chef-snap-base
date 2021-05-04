#
# Cookbook:: snap-base
# Recipe:: active-dir-centos7-configuration
#
# Copyright:: 2021, UAF RCS, All Rights Reserved.

package 'nss-pam-ldapd' do
  action :install
end

template '/etc/nslcd.conf' do
  owner 'root'
  group 'root'
  mode '0600'
  source 'nslcd.conf.erb'
  action :create
end

service 'nslcd' do
  subscribes :restart, 'file[/etc/nslcd.conf]', :immediately
  action [:start, :enable]
end

# Remove secret attributes
ruby_block 'remove-secret-attributes' do
  block do
    node.rm('snap', 'ad-binddn')
    node.rm('snap', 'ad-bindpw')
  end
  subscribes :create, "template['/etc/nslcd.conf']", :immediately
end
