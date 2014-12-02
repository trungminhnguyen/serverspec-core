require 'spec_helper'

# reporting (openstack::reporting)
describe cron do
  it { should have_entry '0 * * * * /opt/cloud/libexec/s3sync.sh 2>&1 > /dev/null' }
  it { should have_entry '12 17 * * * /opt/cloud/bin/bonzlist.sh' }
end
