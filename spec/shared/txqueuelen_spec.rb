def check_txqueue(txqueuelen)
  describe command('ip -o l | sed -n "s/.*qlen \(.*\)\\\\\.*/\1/p" | uniq').stdout.chomp do
    #sting comparision is more reliable here in case of non uniq results,
    # e.g. "1000\n10000"
    it { should eq txqueuelen.to_s }
  end
end

shared_examples 'interfaces txqueuelen is 1.000' do
  check_txqueue(1000)
end

shared_examples 'interfaces txqueuelen is 10.000' do
  check_txqueue(10000)
end
