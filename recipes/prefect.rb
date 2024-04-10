#
# Cookbook:: snap-base
# Recipe:: prefect
#
# Copyright:: 2024, The Authors, All Rights Reserved.

include_recipe 'snap-base::_miniconda_installer'
include_recipe 'snap-base::_install_pm2'

# Determine the FQDN of the node
hostname = node['fqdn'].nil? ? node['name'] : node['fqdn']

# Load the data bag item corresponding to the FQDN
pm2_apps_config = data_bag_item('prefect', hostname)

git '/usr/local/prefect' do
    repository 'https://github.com/ua-snap/prefect.git'
    revision pm2_apps_config['git_branch']
    action :sync
end

directory '/usr/local/pm2' do
    owner 'snapdata'   
    group 'snap_users'   
    mode '0755'          
    recursive true       
    action :create  
end

link '/usr/local/pm2/prefect' do
    to '/usr/local/prefect'
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

# Define a flag to check if any app is not running
app_not_running = false

# Iterate over each app defined in pm2_apps_config
pm2_apps_config['apps'].each do |app|
  # Run the pm2 list command and capture the output
  pm2_list_output = Mixlib::ShellOut.new(". /etc/profile.d/nvm.sh && nvm use lts/gallium && sudo -u snapdata pm2 list").run_command.stdout

  # Check if the app name is listed and its status is "online"
  app_running = pm2_list_output.each_line.any? { |line| line.include?(app['name']) && line.include?('online') }

  # If the app is not running, set the flag to true and break the loop
  unless app_running
    app_not_running = true
    break
  end
end

# Use the flag to conditionally execute the pm2 start command
execute 'run_prefect_scripts' do
  command '. /etc/profile.d/nvm.sh && nvm use lts/gallium && . /opt/miniconda3/bin/activate && prefect config set PREFECT_API_URL=https://prefect.earthmaps.io/api && sudo -u snapdata pm2 start pm2.config.js'
  cwd '/usr/local/pm2'
  action :run
  only_if { app_not_running }
end