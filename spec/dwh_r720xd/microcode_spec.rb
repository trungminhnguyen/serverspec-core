require 'spec_helper'

describe command('cat /proc/cpuinfo | grep 0x | uniq') do
  it { should return_stdout /(0x427|x428)/ }
end
