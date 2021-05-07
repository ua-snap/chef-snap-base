#
# Cookbook:: snap-base
# Recipe:: default
#
# Copyright:: 2021, UAF SNAP, All Rights Reserved.

# add EPEL repository
package ['epel-release']

# link to Alaska timezone
timezone 'America/Anchorage'

# Basic package installs
package %w(bind-utils unzip deltarpm yum-utils ethtool git lsof net-tools pciutils psmisc screen strace tcpdump vim wget) do
  action :install
end

resolver_config '/etc/resolv.conf' do
  nameservers ['137.229.15.5','137.229.5.191']
  domain 'snap.uaf.edu'
  search ['snap.uaf.edu','rcs.alaska.edu','alaska.edu']
end

# Sets up 30 minute default Chef client runs
include_recipe 'chef-client::config'
include_recipe 'chef-client::service'

# Sets up NTPd to keep clock in sync
include_recipe 'ntp::default'

include_recipe 'snap-base::_admins'
include_recipe 'snap-base::_snap_users'
