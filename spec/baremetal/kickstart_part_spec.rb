require 'spec_helper'

describe command('echo $LANG') do
  it {should return_stdout 'en_US.UTF-8'}
end

describe selinux do
    it { should be_permissive }
end

describe 'Linux kernel parameters' do
  # Check if correct options are in action
  context linux_kernel_parameter('vm.swappiness') do
    its(:value) { should eq 10 }
  end
  context linux_kernel_parameter('vm.dirty_expire_centisecs') do
    its(:value) { should eq 3000 }
  end
  context linux_kernel_parameter('vm.dirty_ratio') do
    its(:value) { should eq 12 }
  end
  context linux_kernel_parameter('vm.dirty_writeback_centisecs') do
    its(:value) { should eq 500 }
  end
  context linux_kernel_parameter('vm.dirty_background_ratio') do
    its(:value) { should eq 3 }
  end
  context linux_kernel_parameter('kernel.sem') do
    its(:value) { should eq "500\t256000\t250\t1024" }
  end
  context linux_kernel_parameter('net.ipv4.ip_local_port_range') do
    its(:value) { should eq "30000\t65000" }
  end
  context linux_kernel_parameter('net.ipv4.ip_forward') do
    its(:value) { should eq 1 }
  end

  # Check if correct options are specified in sysctl.d files
  # Pay attention to ^ and $ in regexps
  describe file('/etc/sysctl.d/vm') do
    sysctl_options = '^vm.swappiness \= 10$
^vm.dirty_expire_centisecs \= 3000$
^vm.dirty_ratio \= 12$
^vm.dirty_writeback_centisecs \= 500$
^vm.dirty_background_ratio \= 3$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/semaphores') do
    sysctl_options = '^kernel.sem \= 500 256000 250 1024$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/bridge_iptables') do
    sysctl_options = '^net.bridge.bridge-nf-call-ip6tables \= 1$
^net.bridge.bridge-nf-call-iptables \= 1$
^net.bridge.bridge-nf-call-arptables \= 1$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/net') do
    sysctl_options = 'net.ipv4.ip_local_port_range \= 30000 65000$
^net.ipv4.ip_forward \= 1$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end
end

describe file('/proc/cmdline') do
  its(:content) { should match /elevator=deadline intremap=no_x2apic_optout nomodeset video=efifb/ }
end
