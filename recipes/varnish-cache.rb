#
# Cookbook:: snap-base
# Recipe:: varnish-cache
#
# Copyright:: 2025, The Authors, All Rights Reserved.

domain_name = node.name
node.default['set_fqdn'] = domain_name
admin_email = 'uaf-snap-sys-team@alaska.edu'
cert_path = "/etc/letsencrypt/live/#{domain_name}/fullchain.pem"

# Set hostname 
include_recipe 'hostname::default'


# install varnish
apt_update 'update' do
    action :update
end

package 'varnish' do
  action :install
end

# create varnish configuration directory
directory '/etc/varnish' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

# copy varnish configuration file
cookbook_file '/etc/varnish/default.vcl' do
    source 'default.vcl'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

directory '/etc/systemd/system/varnish.service.d' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

# create systemd service file for varnish
template '/etc/systemd/system/varnish.service.d/override.conf' do
    source 'varnish.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create_if_missing
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

# enable and start varnish service
service 'varnish' do
  action [:enable, :start]
end

ruby_block 'conditionally_restart_varnish' do
  block do
    Chef::Log.info("Restarting Varnish because it is using -s malloc,256m")
    resources(service: 'varnish').run_action(:restart)
  end
  only_if "ps aux | grep '[v]arnishd' | grep -- '-s malloc,256m'"
end

# Create Certbot certificate if not running in Kitchen
unless node['kitchen']
  package 'certbot' do
    action :install
  end
  execute 'certbot certonly request' do
    command "certbot certonly --standalone --non-interactive --agree-tos --email #{admin_email} -d #{domain_name}"
    not_if { ::File.exist?(cert_path) }
    action :run
  end
else
  log "Skipping certbot certificate request in Test Kitchen" do
    level :info
  end
end



# install Nginx for proxying Varnish
package 'nginx' do
  action :install
end

# create Nginx configuration directory for Varnish proxying
directory '/etc/nginx' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

# copy Nginx configuration file for Varnish proxying
template '/etc/nginx/sites-available/varnish' do
  source 'varnish-nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nginx]', :delayed
end

link '/etc/nginx/sites-enabled/varnish' do
  to '/etc/nginx/sites-available/varnish'
  notifies :restart, 'service[nginx]', :delayed
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
  only_if { ::File.exist?('/etc/nginx/sites-enabled/default') }
  notifies :restart, 'service[nginx]', :delayed
end

service 'nginx' do
  action [:enable, :start]
end