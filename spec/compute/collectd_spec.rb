require 'spec_helper'

describe service('collectd') do
  it { should be_enabled }
  it { should be_running }
end

describe host('carbon-proxy-internal.na.intgdc.com') do
  it { should be_reachable.with( :port => 2003 ) }
end
