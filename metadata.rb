name 'snap-base'
maintainer 'UAF SNAP'
maintainer_email 'uaf-snap-sys-team@alaska.edu'
license 'All Rights Reserved'
description 'Installs/Configures snap-base'
long_description 'Installs/Configures snap-base'
version '0.1.21'
chef_version '>= 14.0'

depends 'chef-client'
depends 'ntp'
depends 'firewall'
depends 'user'
depends 'sudo'
depends 'chef-vault'
depends 'resolver'
