require 'rspec/expectations'

RSpec::Matchers.define :be_in do |expected|
  match do
    expected.include?(actual)
  end
end
