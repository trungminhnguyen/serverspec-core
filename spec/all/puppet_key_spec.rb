require 'spec_helper'

describe file('/root/.ssh/puppet_master') do
  it { should match_sha256checksum '8035ed1bfa10fad13cef151e626c70524c8aaba5ec65646d1dcda11a1990a7cc' }
end

# connecting to github
# 255 - auth failure
# 1   - ok, github doesn't offer shell
describe command('ssh github.com') do
  it { should return_exit_status 1 }
end
