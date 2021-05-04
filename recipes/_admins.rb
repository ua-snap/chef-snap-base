#
# Cookbook:: snap-base
# Recipe:: _admins
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.

include_recipe 'chef-vault::default'

#
# add RCS system administrators who need local passwords for sudo
# precreate the staff, software, & sudoers group
group 'rcs-staff' do
  gid 206
  append true
  action :create
end

group 'sudoers' do
  gid 5185
  append true
  action :create
end

directory '/home' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

include_recipe 'user::default'

bash 'add jsdabney user' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  getent passwd jsdabney >> /etc/passwd
  EOH
  not_if "grep jsdabney /etc/passwd"
  ignore_failure true
  action :run
end

bash 'add rltorgerson user' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  getent passwd rltorgerson >> /etc/passwd
  EOH
  not_if "grep rltorgerson /etc/passwd"
  ignore_failure true
  action :run
end

bash 'add crstephenson user' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  getent passwd crstephenson >> /etc/passwd
  EOH
  not_if "grep crstephenson /etc/passwd"
  ignore_failure true
  action :run
end

# Start an exception block in case the admins-vault does not exist in
# testing or production.
begin
  data_bag('admins-vault').each do |user|
    if !user.include? '_keys'
      curr_user = chef_vault_item('admins-vault', user)
      if !curr_user['ssh_keys'].nil?
        ssh_keys = curr_user['ssh_keys']
      else
        ssh_keys = []
      end
      if (!node['etc']['passwd'][user]) || (curr_user['forcepass'])
        user_account curr_user['id'] do
          comment curr_user['comment']
          uid curr_user['uid']
          gid curr_user['gid']
          home curr_user['home']
          shell curr_user['shell']
          password curr_user['password']
          ssh_keys ssh_keys
          groups curr_user['groups']
          action :create
        end
      else
        user_account curr_user['id'] do
          comment curr_user['comment']
          uid curr_user['uid']
          gid curr_user['gid']
          home curr_user['home']
          shell curr_user['shell']
          ssh_keys ssh_keys
          groups curr_user['groups']
          action :create
        end
      end
    end
  end
rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
  log 'admin-vault error' do
    level :warn
    message 'The admin-vault was not found. No admins added to provisioned system.'
  end
end

include_recipe 'sudo::default'
