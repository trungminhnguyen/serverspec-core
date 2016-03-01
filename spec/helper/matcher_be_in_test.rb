# Copyright (c) 2016, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.
#
# This is a test for spec/helper/matcher_be_in_test.rb
#
# To run this test just:
# $ serverspec-core selfcheck
# or
# $ serverspec-core selfcheck SPEC=/etc/puppet/spec/helper/matcher_be_in_test.rb
#
require 'spec_helper'

# Test be_in matcher in standalone mode
describe 'passing examples' do
  describe 'bar' do
    it { should be_in %w(foo bar) }
    it { should_not be_in %w(foo baz) }
  end
end

describe 'failing examples' do
  describe 'baz' do
    it do
      expect do
        subject should be_in %w(foo bar)
      end.to raise_error(
        RSpec::Expectations::ExpectationNotMetError, 'expected "baz" to be in "foo" and "bar"'
      )
    end
    it do
      expect do
        subject should_not be_in %w(foo baz)
      end.to raise_error(
        RSpec::Expectations::ExpectationNotMetError, 'expected "baz" not to be in "foo" and "baz"'
      )
    end
  end
end
