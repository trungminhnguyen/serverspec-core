require 'spec_helper'

describe file('/etc/logrotate.d/dnsmasq-nova') do
  it { should be_file }
  it { should match_sha256checksum 'cd54a63449bb083f898134374abbaf5848160b055b7275a1b8574f5fc16989db' }
end

describe file('/etc/logrotate.d/openstack-nova') do
  it { should be_file }
  it { should match_sha256checksum 'd3e8a818fa6fe29f38964c7bfe80688d0b4290e3ef60a9f1e575984f22053eb3' }
end

treshold = 204800
describe command("du /var/log/nova/*.log | awk '{print $1}'| xargs -i test {}  -le #{treshold}") do
  it { should return_exit_status 0 }
end

describe command("du /var/log/dnsmasq.log | awk '{print $1}'| xargs -i test {}  -le #{treshold}") do
  it { should return_exit_status 0 }
end
