require 'spec_helper'

describe 'Nova volume' do
  it_behaves_like 'compute node with local EBS'
end
