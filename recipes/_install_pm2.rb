#
# Cookbook:: snap-base
# Recipe:: _install_pm2
#
# Copyright:: 2024, The Authors, All Rights Reserved.

nvm_install_dir = '/usr/local/nvm'

 directory '/usr/local/nvm' do
    owner 'root'   
    group 'root'   
    mode '0755'          
    recursive true       
    action :create  
end

execute 'install_nvm' do
    command "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | NVM_DIR=#{nvm_install_dir} bash"
    not_if { ::File.exist?("#{nvm_install_dir}/install.sh") }
    action :run
  end
  
  
cookbook_file '/etc/profile.d/nvm.sh' do
    source 'nvm.sh'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
  
# Install Node.js and pm2 using NVM
execute 'install_nodejs_npm_and_pm2' do
    command '. /etc/profile.d/nvm.sh && nvm install lts/gallium && nvm alias default lts/gallium && npm install -g pm2'
    not_if 'which npm'
    action :run
end