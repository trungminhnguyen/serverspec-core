require 'spec_helper'

describe command('omreport storage vdisk') do
 it { should return_stdout /^Layout\s+: RAID-6$/ }
 it { should return_stdout /^Read Policy\s+: No Read Ahead$/ }
 it { should return_stdout /^Write Policy\s+: Write Back$/ }
 it { should return_stdout /^Stripe Element Size\s+: 64 KB$/ }
end
