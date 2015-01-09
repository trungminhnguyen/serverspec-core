require 'spec_helper'

expected_packages = ['openstack-nova-network', 
                     'openstack-nova-common',
                     'openstack-nova-volume',
                     'openstack-nova-api',
                     'openstack-nova-compute']

expected_version = '2012.2.4-37.el6'

check_packages(expected_packages, expected_version)
