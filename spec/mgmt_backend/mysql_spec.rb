require 'spec_helper'

describe service('common-mysqld') do
  it { should be_running }
  it { should be_enabled }
end

describe service('mysql') do
  it { should be_monitored_by('monit') }
end

describe 'mysql should listen on internal only' do
    describe port(3306) do
      it { should be_listening }
    end

    describe host('mgmt-backend01.na.getgooddata.com') do
      it { should_not be_reachable.with( :port => 3306 )}
    end

    describe host('mgmt-backend01.int.na.getgooddata.com') do
      it { should be_reachable.with( :port => 3306 )}
    end
end
