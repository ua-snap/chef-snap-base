#
# Cookbook:: snap-base
# Recipe:: _rasdaman_coverage_binaries
#
# Copyright:: 2024, UAF SNAP, All Rights Reserved.

cookbook_file '/usr/local/bin/add_coverage.sh' do
    source 'add_coverage.sh'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

cookbook_file '/usr/local/bin/delete_coverage.sh' do
    source 'delete_coverage.sh'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end