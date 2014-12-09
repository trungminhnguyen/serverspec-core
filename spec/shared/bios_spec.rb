require 'spec_helper'

shared_examples 'hardware node with correct bios settings' do
  describe command('/opt/cloud/bin/check_bios.sh -r') do
    its(:stdout) { should_not match /FAIL/ }
  end
end
