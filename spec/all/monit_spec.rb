require 'spec_helper'

describe package('monit') do
  it { should be_installed }
end

describe service('monit') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/monit.conf') do
  it { should be_file }
  monit_conf  = %q{set daemon      30
set logfile     /var/log/monit

set httpd port 2812 and
    allow admin:monit
    allow localhost

include /etc/monit.d/*.conf
}
  its(:content) { should eq monit_conf }
end

# on all hosts we have active monitoring of ssh
describe file('/etc/monit.d/sshd.conf') do
  it { should be_file }
  sshd_conf = %q{check process sshd
    pidfile /var/run/sshd.pid
    start program = "/etc/init.d/sshd start"
    stop  program = "/etc/init.d/sshd stop"
    # sshd is not listening on loopback
    #if failed port 22 then alert
    mode active
}
  its(:content) { should eq sshd_conf }
end

# and ssh is the only active
describe command('grep "mode active" /etc/monit.d/*.conf | wc -l').stdout.to_i do
  it { should eq 1 }
end
