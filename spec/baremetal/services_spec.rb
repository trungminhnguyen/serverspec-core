require 'spec_helper'

['libvirtd', 'munin-node', 'collectd'].each do |s|
  describe service(s) do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
