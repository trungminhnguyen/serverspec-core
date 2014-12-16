require 'spec_helper'

describe 'scheduler - limits' do
  check_limits('/var/run/nova/nova-scheduler.pid', 4096, 4096, 8192)
end

describe 'rabbit - limits' do
  check_limits('/var/run/rabbitmq/pid', 4096, 8192, 8192)
end
