require 'spec_helper'

# lu and lu2 CURE utilities (openstack::lu)

# If DB settings are ok lu exits with 0 otherwise 1
describe command('/usr/local/bin/lu') do
  it { should return_exit_status 0 }
end
