#
# Cookbook:: snap-base
# Recipe:: _miniconda_installer
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# Define the URL for Miniconda3 installer
miniconda_url = 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh'

# Define the installation directory
miniconda_install_dir = '/opt/miniconda3'

# Download the Miniconda installer
remote_file '/tmp/miniconda.sh' do
  source miniconda_url
  mode '0755'
  action :create
end

# Execute the Miniconda installer
execute 'install_miniconda' do
    command "/bin/bash /tmp/miniconda.sh -b -p #{miniconda_install_dir}"
    not_if { ::File.exist?("#{miniconda_install_dir}/bin/python") }
    action :run
    notifies :run, 'execute[install_prefect]', :immediately
  end
  
  # Install or upgrade Prefect in the base environment
  execute 'install_prefect' do
    command "#{miniconda_install_dir}/bin/pip install prefect==2.14.2 paramiko"
    action :nothing
  end