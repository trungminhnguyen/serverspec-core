require 'spec_helper'

describe package('openstack-nova') do
  it { should be_installed.with_version('2012.2.4-35.el6') }
end
