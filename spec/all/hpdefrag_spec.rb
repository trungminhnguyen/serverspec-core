require 'spec_helper'

describe file('/sys/kernel/mm/transparent_hugepage/defrag') do
  its(:content) { should match /\[never\]/ }
end
