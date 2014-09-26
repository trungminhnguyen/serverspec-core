require 'spec_helper'

munin_packages = ['munin-node', 'oam-munin-plugins', 'munin-common', 'munin-java-plugins']

munin_packages.each do |package|
  describe package(package) do
    it { should_not be_installed }
  end
end

describe service('munin-node') do
  it { should_not be_enabled }
  it { should_not be_running }
end
