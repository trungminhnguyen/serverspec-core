require 'spec_helper'

describe command('racadm get System.Power.HotSpare.Enable') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /Disabled/ }
end

describe command('racadm get System.Power.RedundancyPolicy') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /Input Power Redundant/ }
end

