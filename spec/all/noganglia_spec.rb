require 'spec_helper'

describe service('gmond') do
  it { should_not be_enabled }
  it { should_not be_running }
end
