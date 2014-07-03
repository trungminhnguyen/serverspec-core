require 'spec_helper'

describe file('/root/.ssh/puppet_master') do
  it { should match_sha256checksum 'a02a687d704b1ec0fa47fc0b09533ab2d4498291282a3374944f8a7f8c2f809c' }
end

# connecting to github
# 255 - auth failure
# 1   - ok, github doesn't offer shell
describe command('ssh github.com') do
  it { should return_exit_status 1 }
end
