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

# Create PM2 configuration file
template 'pm2_configuration' do
  path '/usr/local/pm2/pm2.config.js'
  source 'pm2.config.js.erb'
  variables(
    apps: pm2_apps_config['apps']
  )
  action :create
end

ruby_block 'list_directory_contents' do
    block do
      directory_path = '/usr/local/prefect'
  
      if Dir.exist?(directory_path)
        Dir.foreach(directory_path) do |entry|
          Chef::Log.info("File: #{entry}")
        end
      else
        Chef::Log.warn("Directory #{directory_path} does not exist.")
      end
    end
    action :run
  end

  ruby_block 'list_directory_contents' do
    block do
      directory_path = '/usr/local/pm2'
  
      if Dir.exist?(directory_path)
        Dir.foreach(directory_path) do |entry|
          Chef::Log.info("File: #{entry}")
        end
      else
        Chef::Log.warn("Directory #{directory_path} does not exist.")
      end
    end
    action :run
  end