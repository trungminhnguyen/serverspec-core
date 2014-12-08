def check_txqueue(txqueuelen)
  command('ip -o l | grep qlen').stdout.each_line do |line|
    describe line do
      it { should match /qlen #{txqueuelen}\\/ }
    end
  end
end

shared_examples 'interfaces txqueuelen is 1.000' do

  describe 'txqueue is 1.000' do
    check_txqueue(1000)
  end

end

shared_examples 'interface txqueuelen is 10.000' do

  describe 'txqueue is 1.000' do
    check_txqueue(10000)
  end

end
