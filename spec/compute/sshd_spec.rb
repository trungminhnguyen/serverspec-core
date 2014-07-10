require 'spec_helper'

describe service('sshd') do
  it { should be_enabled   }
  it { should be_running   }
end

describe 'sshd_ports' do
  it 'should listen on one iface' do
    c = command('netstat -apln | egrep -c "LISTEN\s+[0-9]+/sshd"').stdout.to_i
    c.should == 1
  end
  it 'should listen only on priv net' do
    ip = command('facter ipaddress_bond1_282').stdout.strip
    c = command('netstat -apln | egrep -c "%s:22.* LISTEN"' % [ip,]).stdout.to_i
    c.should == 1
  end
end
