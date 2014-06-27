describe service('collectd') do
  it { should_not be_enabled }
  it { should_not be_running }
end
