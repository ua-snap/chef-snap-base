name 'snap-base'
maintainer 'UAF SNAP'
maintainer_email 'uaf-snap-sys-team@alaska.edu'
license 'All Rights Reserved'
description 'Installs/Configures snap-base'
long_description 'Installs/Configures snap-base'
version '0.2.0'
chef_version '>= 14.0'

depends 'chef-client', '= 12.3.4'
depends 'firewall', '= 2.7.0'
depends 'user', '= 0.7.0'
depends 'sudo', '= 5.4.6'
depends 'chef-vault', '= 4.0.3'
depends 'resolver', '= 3.0.4'
depends 'logrotate', '= 2.3.0'
depends 'selinux', '= 3.1.1'
