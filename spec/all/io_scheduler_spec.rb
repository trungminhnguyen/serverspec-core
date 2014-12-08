require 'spec_helper'

describe 'all devices should have deadline scheduler' do
    command('cat /sys/block/{v,s}d{a..z}/queue/scheduler').stdout.each_line { |line|
      describe line do
        it { should match /\[deadline\]/ }
      end
    }
end
