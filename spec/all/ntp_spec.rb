require 'spec_helper'

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/monit.d/ntpd.conf') do
  it { should be_file }
  ntpd_conf  = %q{check process ntpd
    pidfile /var/run/ntpd.pid
    mode passive
}
  its(:content) { should eq ntpd_conf }
end
