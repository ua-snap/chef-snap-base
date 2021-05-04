#
# Cookbook:: snap-base
# Recipe:: _admins
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.

include_recipe 'chef-vault::default'

# add RCS system administrators who need local passwords for sudo
# precreate the staff, software, & sudoers group
group 'snap_users' do
  gid 17375414
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

# Start an exception block in case the admins-vault does not exist in
# testing or production.
begin
  data_bag('users-vault').each do |user|
    if !user.include? '_keys'
      curr_user = chef_vault_item('users-vault', user)
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
  log 'users-vault error' do
    level :warn
    message 'The users-vault was not found. No additional users added to provisioned system.'
  end
end
