#
# Cookbook:: snap-base
# Recipe:: geoserver
#
# Copyright:: 2024, The Authors, All Rights Reserved.

#node.default['authorization']['sudo']['custom_commands']["groups"] = [{"group": "snap_users", "passwordless": true, "command_list": ["/tmp/smokey-bear/update_smokey_bear.sh", "/tmp/smokey-bear/update_snow_cover.sh"]}]

include_recipe 'snap-base::_admins'
include_recipe 'snap-base::_snap_users'

sudo 'snapdata' do
    users 'snapdata'
    nopasswd true
    commands ['/tmp/smokey-bear/update_smokey_bear.sh', '/tmp/smokey-bear/update_snow_cover.sh']
end