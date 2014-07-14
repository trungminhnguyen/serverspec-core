require 'spec_helper'

describe package('openstack-nova-scheduler') do
  it { should be_installed.with_version('2012.2.4-32.el6.gdc') }
end

describe service('openstack-nova-scheduler') do
  it { should be_running }
  it { should be_enabled }
end

describe service('nova-scheduler') do
  it { should be_monitored_by('monit') }
end
