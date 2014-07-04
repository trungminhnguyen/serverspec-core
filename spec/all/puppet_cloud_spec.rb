require 'spec_helper'

# Check if we're on origin and master
describe command('git --git-dir=/etc/puppet/.git/ branch -vv') do
  its(:stdout) { should match Regexp.new('^\* master\s+[0-9a-z]+ \[origin/master\].*') }
end

# Check if origin is correct one
describe command('git --git-dir=/etc/puppet/.git/ remote -v') do
  its(:stdout) {should match Regexp.new('^origin\s+git@github.com:gooddata/puppet-cloud.git.*') }
end
