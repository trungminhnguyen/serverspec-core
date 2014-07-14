require 'spec_helper'

# reporting (openstack::reporting)
describe cron do
  it { should have_entry '0 * * * * /opt/cloud/libexec/s3sync.sh 2>&1 > /dev/null' }
  it { should have_entry '12 17 * * * /opt/cloud/bin/bonzlist.sh' }
end

describe command('s3cmd -c /etc/opt/cloud/.s3cfg ls s3://gdc-ms-int/AIDAITKADXPFIBCFHLOUS_gdc-ms-int_adwh/') do
  its(:stdout) { should match Regexp.new('s3://gdc-ms-int/AIDAITKADXPFIBCFHLOUS_gdc-ms-int_adwh/na-volumes.csv') }
end
