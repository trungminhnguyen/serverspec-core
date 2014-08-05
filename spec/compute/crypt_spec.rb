require 'spec_helper'

describe 'encryption', tag: 'crypt' do
  it 'should have 256 keysize' do
    keysizes = command("ls -1 /dev/mapper/luks-* | xargs -n1 cryptsetup status|grep keysize| awk '{print $2}'").stdout
    keysizes.should_not be_empty
    keysizes.split.each do |keysize| 
      keysize.to_i.should eq 256
    end
  end

  describe file('/boot') do
    it { should be_mounted.with( :type => 'ext4' ) }
  end
  describe file('/boot/efi') do
    it { should be_mounted.with( :type => 'vfat' ) }
  end

  it 'has all physical partitions except /boot and /boot/efi are encrypted' do
    crypts = command("blkid | grep \/sda|tail -n +3|awk '{print $3}'").stdout
    crypts.split.length.should > 0
    crypts.split.each do |type|
      type.should == 'TYPE="crypto_LUKS"'
    end
  end
end
