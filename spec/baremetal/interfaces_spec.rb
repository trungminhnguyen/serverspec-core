require 'spec_helper'

# "Bottom interfaces should be down"
['p4p2', 'p5p2'].each do |i|
  describe command('ip -o link show #{i}') do
    its(:stdout) { should match /state DOWN/ }
  end
end

# "Upper" interfaces should be up and in bond0
['p4p1', 'p5p1'].each do |i|
  describe command('ip -o link show ${i}') do
    its(:stdout) { should match /master bond0 state UP/ }
  end
end

# Only 2 devices shoud have IPs (lo, bond0)
describe "Only 2 devices shoud have IPs (lo, bond0)" do
  command('ip -o -4 a | wc -l').stdout.to_i { should eq 2 }
end

describe command('ip -o -4 a show bond0') do
  ip_match = '172.30.64.1(08|09|10|11|12)\/18 brd 172.30.127.255'
  its(:stdout) { should match Regexp.new(ip_match) }
end
