require 'spec_helper'

describe command('omreport storage vdisk') do
 it { should return_stdout /^Layout\s+: RAID-6$/ }
 it { should return_stdout /^Read Policy\s+: No Read Ahead$/ }
 it { should return_stdout /^Write Policy\s+: Write Back$/ }
 it { should return_stdout /^Stripe Element Size\s+: 64 KB$/ }
end

# 24 disks = 23 + 1 hot spare
describe command('omreport storage pdisk controller=0|grep "Hot Spare.*: No"|wc -l') do
  if command("omreport storage pdisk controller=0|awk '/Media/ {print $3}'|uniq").stdout.chomp == 'SSD'
    it { should return_stdout '11' }
  else
    it { should return_stdout '23' }
  end
end

describe command('omreport storage pdisk controller=0|grep "Hot Spare.*: Dedicated"|wc -l') do
  it { should return_stdout '1' }
end
