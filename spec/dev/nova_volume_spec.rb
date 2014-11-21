require 'spec_helper'

describe 'Nova volume' do
  it_behaves_like 'compute node without local EBS'
end
