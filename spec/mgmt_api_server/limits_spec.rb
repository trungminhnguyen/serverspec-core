require 'spec_helper'

describe 'nova - limits' do
  check_limits('/var/run/nova/nova-api.pid', 4096, 4096, 8192)
end
