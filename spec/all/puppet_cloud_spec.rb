require 'spec_helper'

# Check if we're on origin and master
describe command('git --git-dir=/etc/puppet/.git/ branch -vv') do
  its(:stdout) { should match Regexp.new('^\* master\s+[0-9a-z]+ \[origin/master\].*') }
end

# Check if origin is correct one
describe command('git --git-dir=/etc/puppet/.git/ remote -v') do
  its(:stdout) {should match Regexp.new('^origin\s+git@github.com:gooddata/puppet-cloud.git.*') }
end

# Desired puppet version
describe package('puppet') do
  its(:version) { should >= '3.6' }
end

# puppet 3.6 compatibility
describe file('/etc/puppet/puppet.conf') do
  it {should_not contain 'modulepath'}
  it {should_not contain 'manifest'}
  it { should contain 'environmentpath = $confdir/environments/' }
end

describe command('rpm -q --queryformat "%{version}-%{release}" oam-puppet-cloud') do
  its(:stdout) { should eq '1.0-6' }
end
