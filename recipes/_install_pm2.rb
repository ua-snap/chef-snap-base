#
# Cookbook:: snap-base
# Recipe:: _install_pm2
#
# Copyright:: 2024, The Authors, All Rights Reserved.

 nvm_install_dir = '/usr/local/nvm'

execute 'install_nvm' do
    command 'export NVM_DIR=#{nvm_install_dir} && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | NVM_DIR=$NVM_DIR bash'
    not_if { ::File.exist?('/usr/local/nvm') } # Add a guard to avoid reinstallation
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
execute 'install_nodejs_npm' do
    command 'nvm install lts/hydrogen && npm install -g pm2'
    not_if 'which node'
    action :run
    notifies :run, 'execute[source_nvm]', :immediately
end
  
# Source NVM to make it available in the current shell
execute 'source_nvm' do
    command 'source /etc/profile.d/nvm.sh'
    action :nothing
end