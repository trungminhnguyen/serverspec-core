require 'spec_helper'

describe file('/etc/hosts') do
  it { should be_file }
  it { should be_readable }
end
