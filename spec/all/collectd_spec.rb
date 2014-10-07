require 'spec_helper'

describe service('collectd') do
  it { should be_enabled }
  it { should be_running }
end

describe host('carbon-proxy-internal.na.intgdc.com') do
  it { should be_reachable.with( :port => 2003 ) }
end

describe "PCI-3977" do
  netlink = 'LoadPlugin netlink
<Plugin netlink>
  Interface "All"
  VerboseInterface "lo"
  QDisc "lo"
  IgnoreSelected yes
</Plugin>'

  describe file('/etc/collectd.d/netlink.conf') do
    its(:content) { should match Regexp.new(netlink) }
  end

  common = 'LoadPlugin interface
<Plugin interface>
    Interface "lo"
    IgnoreSelected true
</Plugin>'

  describe file('/etc/collectd.d/common.conf') do
    its(:content) { should match Regexp.new(common) }
  end
end

describe "PCI-3832" do
  describe command('rpm -q --queryformat "%{version}-%{release}" collectd') do
    its(:stdout) { should eq '5.4.1-7.gdc.el6' }
  end
end
