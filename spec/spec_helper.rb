# Copyright (c) 2016, GoodData Corporation. All rights reserved.
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

# encoding: utf-8
require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'rspec/its'
require './cfg/cfg_helper'

# init SPEC_DIR so it can be used in specs
SPEC_DIR = get_config_option('SPEC_DIR', './spec')

# Include helpers
Dir[SPEC_DIR + '/**/*_helper.rb', './spec/**/*_helper.rb'].sort.each { |f| require f }

# Include custom resource types, by default they should be in packaged /types
# and configured SPEC_DIR/types
Dir['./spec/types/*.rb'].sort.each { |f| require f }
Dir[SPEC_DIR + '/types/*.rb'].sort.each { |f| require f }
include Serverspec::Type

backend = ENV['SERVERSPEC_BACKEND'] || :ssh
set :backend, backend
set :ssh_options, user: 'root'
set :path, '$PATH:/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin'

RSpec.configure do |c|
  c.expect_with :rspec do |config|
    config.syntax = [:should, :expect]
  end
  c.disable_sudo = true
  c.host = ENV['TARGET_HOST']

  labels = (ENV['TARGET_LABELS'] || '').split(',')
  c.filter_run_excluding label: ->(l) { !labels.include?(l) }
end
