require 'spec_helper'

# RabbitMQ (rabbitmq::init)
describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_enabled }
  it { should be_running }
  it { should be_monitored_by('monit') }
end

describe 'rabbitmq-server should listen on internal only' do
    describe port(5672) do
        it { should be_listening }
    end

    describe host('mgmt-backend01.na.getgoodata.com') do
      it { should_not be_reachable.with( :port => 5672 )}
    end

    describe host('mgmt-backend01.int.na.getgoodata.com') do
      it { should_not be_reachable.with( :port => 5672 )}
    end
end
