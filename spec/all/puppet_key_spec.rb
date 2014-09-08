require 'spec_helper'

describe file('/root/.ssh/puppet_master') do
  it { should match_sha256checksum '89fc621505e844b99bfb14f7856b1119bee61dbbec202e346c78a160dda65482' }
end

# connecting to github
# 255 - auth failure
# 1   - ok, github doesn't offer shell
describe command('ssh github.com') do
  it { should return_exit_status 1 }
end
