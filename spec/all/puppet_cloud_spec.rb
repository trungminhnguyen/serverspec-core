require 'spec_helper'

# Check if we're on origin and master
describe command('cd /etc/puppet && git branch -vv') do
  it { should match Regexp.new('^\* master\s+[0-9a-z]+ \[origin/master\]') }
end

# Check if origin is correct one
describe command('cd /etc/puppet && git remote -v') do
  it {should match Regexp.new('^origin\s+git@github.com:gooddata/puppet-cloud.git') }
end
