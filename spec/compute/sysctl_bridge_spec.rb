describe 'Kernel parametes for bridges' do
  context linux_kernel_parameter('net.bridge.bridge-nf-call-ip6tables') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.bridge.bridge-nf-call-iptables') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.bridge.bridge-nf-call-arptables') do
    its(:value) { should eq 1 }
  end
end
