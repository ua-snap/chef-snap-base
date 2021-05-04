default['snap']['admin_email'] = 'rltorgerson@alaska.edu'
default['snap']['admin_user'] = 'rltorgerson'

default['snap']['ad-bind_user'] = 'snap-read'

override['firewall']['ipv6_enabled'] = false
override['firewall']['firewalld']['permanent'] = true
override['firewall']['allow_established'] = true
override['firewall']['allow_loopback'] = true
override['firewall']['allow_icmp'] = false

# Make it so everyone in the sudoers group has sudo
node.default['authorization']['sudo']['groups'] = ['sudoers']

# Add include sudoers.d as a place for sudo rules
node.default['authorization']['sudo']['include_sudoers_d'] = true

# Should the sudo be passwordless for all members of the above group?
node.default['authorization']['sudo']['passwordless'] = false
