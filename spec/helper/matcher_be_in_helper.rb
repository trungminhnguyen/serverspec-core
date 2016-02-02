# Copyright (c) 2016, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

require 'rspec/expectations'

RSpec::Matchers.define :be_in do |expected|
  match do
    expected.include?(actual)
  end
end
