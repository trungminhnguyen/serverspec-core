require 'spec_helper'

describe package('openstack-keystone') do
  it { should be_installed.with_version('2012.2.4-3.el6.gdc1') }
end

describe service('openstack-keystone') do
  it { should be_running }
  it { should be_enabled }
end

describe service('keystone') do
  it { should be_monitored_by('monit') }
end

describe 'keystone APIs should listen on internal net only ' do
    describe port(5000) do
      it { should be_listening }
    end

    describe host('mgmt-backend01.na.getgooddata.com') do
      it { should_not be_reachable.with( :port => 5000 )}
    end

    describe host('mgmt-backend01.int.na.getgooddata.com') do
      it { should be_reachable.with( :port => 5000 )}
    end

    describe port(35357) do
      it { should be_listening }
    end

    describe host('mgmt-backend01.na.getgooddata.com') do
      it { should_not be_reachable.with( :port => 35357 )}
    end

    describe host('mgmt-backend01.int.na.getgooddata.com') do
      it { should be_reachable.with( :port => 35357 )}
    end
end


