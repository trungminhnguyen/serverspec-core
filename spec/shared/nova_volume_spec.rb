shared_examples 'compute node with local EBS' do

  describe command('pgrep tgtd | wc -l').stdout.to_i do
    it { should eq 2 }
  end

  describe service('openstack-nova-volume') do
    it { should be_enabled }
    it { should be_running }
  end

end

shared_examples 'compute node without local EBS' do

  describe command('pgrep tgtd | wc -l').stdout.to_i do
    it { should eq 0 }
  end

  describe service('openstack-nova-volume') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

end
