#
# Cookbook:: rcs-server
# Recipe:: _pam_ldap_ad
#
# The MIT License (MIT)
#
# Copyright:: 2017, UAF RCS
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

node.default['snap']['ad-binddn'] = chef_vault_item('ad-vault', node['snap']['ad-bind_user'])['dn']
node.default['snap']['ad-bindpw'] = chef_vault_item('ad-vault', node['snap']['ad-bind_user'])['password']

package 'pam_ldap' do
  action :install
end

cookbook_file '/etc/pam.d/password-auth' do
  source 'password-auth'
  owner 'root'
  group 'root'
  mode '0644'
  manage_symlink_source true
end

cookbook_file '/etc/pam.d/system-auth' do
  source 'system-auth'
  owner 'root'
  group 'root'
  mode '0644'
  manage_symlink_source true
end

cookbook_file '/etc/pki/ca-trust/source/anchors/incommon_CA.crt' do
  source 'incommon_CA.crt'
  owner 'root'
  group 'root'
  mode '0644'
end

if node['platform_family'].include?('rhel')
  if node['platform_version'].to_f >= 7.0
    include_recipe 'snap-base::_pam_ldap_ad_centos7'
  elsif node['platform_version'].to_f >= 6.0
    include_recipe 'snap-base::_pam_ldap_ad_centos6'
  end
end
