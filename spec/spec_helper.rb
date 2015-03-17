# encoding: utf-8
require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'rspec/its'

# Include shared examples
Dir["./spec/*/shared_helper.rb"].sort.each { |f| require f }
# Include custom resource types
Dir["./spec/types/*.rb"].sort.each { |f| require f }
include Serverspec::Type

backend = ENV['SERVERSPEC_BACKEND'] || :ssh
set :backend, backend
set :ssh_options, :user => 'root'
set :path, '$PATH:/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin:/usr/local/sbin'

RSpec.configure do |c|
  c.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  c.disable_sudo = true
  c.host  = ENV['TARGET_HOST']
  options = Net::SSH::Config.for(c.host)

  tags = (ENV['TARGET_TAGS'] || '').split(',')
  c.filter_run_excluding tag: ->(t) { !tags.include?(t) }
end
