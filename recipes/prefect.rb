#
# Cookbook:: snap-base
# Recipe:: prefect
#
# Copyright:: 2024, The Authors, All Rights Reserved.

include_recipe 'snap-base::_miniconda_installer'
include_recipe 'snap-base::_install_pm2'

# Determine the FQDN of the node
# hostname = node['fqdn']

hostname = "gs.mapventure.org"

# Load the data bag item corresponding to the FQDN
pm2_apps_config = data_bag_item('prefect', hostname)

git '/usr/local/prefect' do
    repository 'https://github.com/ua-snap/prefect.git'
    revision pm2_apps_config['git_branch']
    action :checkout
  end

directory '/usr/local/pm2' do
    owner 'snapdata'   
    group 'snap_users'   
    mode '0755'          
    recursive true       
    action :create  
end

# Create PM2 configuration file
template 'pm2.config.js' do
  path '/usr/local/pm2/pm2.config.js'
  source 'pm2.config.js.erb'
  variables(
    apps: pm2_apps_config['apps']
  )
  action :create
end