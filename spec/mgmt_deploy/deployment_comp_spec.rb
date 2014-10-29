require 'spec_helper'

# http (nginx)
describe 'http (nginx)' do

  # we're ensuring version in puppets so check it
  describe package('nginx') do
    it { should be_installed.with_version('1.6.1-1.el6.ngx.gdc') }
  end

  describe service('nginx') do
    it { should be_running }
    it { should be_enabled }
  end

  describe port(8080) do
    it { should be_listening.with('tcp') }
  end

  describe host('mgmt-repo02.int.na.getgooddata.com') do
    it { should be_reachable.with( :port => 8080 )}
  end

  describe host('cmdb.na.getgooddata.com') do
    it { should be_reachable.with( :port => 443 )}
  end

  # TODO test if you realy get a kickstart file, image file...
  
end

# dhcpd

describe 'dhcpd' do

  describe port(67) do
     it { should be_listening.with('udp') }
  end

  describe service('dhcpd') do
    it { should be_running }
    it { should be_enabled }
  end

  # TODO test if you realy get an address

end

# dnsmasq

describe 'dnsmasq' do

  describe port(53) do
    it { should be_listening.with('udp') }
  end

  describe service('dnsmasq') do
    it { should be_running }
    it { should be_enabled }
  end

  # TODO test if it resolves

end

# tftp

describe 'tftpd' do

    describe port(69) do
      it { should be_listening.with('udp') }
    end

    describe service('xinetd') do
      it { should be_running }
      it { should be_enabled }
    end

    # TODO test if you realy get a file
end

# deployment-cure

describe 'deployment-cure' do
  # Check if we're on origin and master
  describe command('git --git-dir=/opt/deployment-cure/.git/ branch -vv') do
    its(:stdout) { should match Regexp.new('^\* master\s+[0-9a-z]+ \[origin/master\].*') }
  end

# Check if origin is correct one
  describe command('git --git-dir=/opt/deployment-cure/.git/ remote -v') do
    its(:stdout) {should match Regexp.new('^origin\s+git@github.com:gooddata/deployment-cure.git.*') }
  end
end
