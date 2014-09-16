require 'spec_helper'

describe command('/opt/cloud/bin/check_bios.sh -r') do
  its(:stdout) { should_not match /FAIL/ }
end
