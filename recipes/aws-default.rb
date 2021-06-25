#
# Cookbook:: snap-base
# Recipe:: aws-default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

# link to Alaska timezone
timezone 'America/Anchorage'

# Basic package installs
package %w(bind-utils unzip deltarpm yum-utils ethtool git lsof net-tools pciutils psmisc screen strace tcpdump vim wget) do
  action :install
end

# Sets up 30 minute default Chef client runs
include_recipe 'chef-client::config'
include_recipe 'chef-client::service'

# Sets up NTPd to keep clock in sync
include_recipe 'ntp::default'

include_recipe 'snap-base::_admins'
include_recipe 'snap-base::_snap_users'
