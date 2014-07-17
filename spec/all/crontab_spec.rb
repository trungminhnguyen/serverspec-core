require 'spec_helper'

describe command('crontab -l') do
  its(:stdout) { should match /MAILTO=rackspace-tickets@gooddata.com/ }
end
