require 'spec_helper'

describe 'Connectivity check' do

  # Management network 172.30.192.0/2 should be accessible
  describe host('mgmt-backend01.na.getgooddata.com') do
    it { should be_reachable }
    it { should be_reachable.with( :port => 22 )}
  end

  # Instances in PROD should NOT be reachable
  describe host('na1-pdwh01.int.na.getgooddata.com') do
    it { should_not be_reachable }
    it { should_not be_reachable.with( :port => 22 )}
    it { should_not be_reachable.with( :port => 3306 )}
  end

  # PXE network should NOT be reachable
  describe host('deploy.pxe.na.getgooddata.com') do
    it { should_not be_reachable }
    it { should_not be_reachable.with( :port => 22) }
  end

  # Internet hosts should be reachable
  describe host('github.com') do
    it { should be_reachable }
    it { should be_reachable.with( :port => 443) }
  end

  # Rest of hosts should be reachable
  describe "Rest of hosts should be reachable" do
    
    baremetal_hosts = [108,109,110,111,112]
    baremetal_hosts.each do |baremetal_host|
      describe host("172.30.64.#{baremetal_host}") do
        it { should be_reachable }
        it { should be_reachable.with( :port => 22 ) }
      end
    end
  end

end
