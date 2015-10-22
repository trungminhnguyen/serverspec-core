require 'spec_helper'

describe file('/etc/hosts'), label: 'hp' do
  it { should be_file }
  it { should be_readable }
end

describe file('/etc/passwd'), label: 'dell' do
 it { should be_readable }
end

describe service('whatever') do
  it { should be_running }
end
