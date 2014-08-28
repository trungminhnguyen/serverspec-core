require 'spec_helper'

crontab_check = 'crontab -l'

describe command(crontab_check) do
  unless command(crontab_check).stderr.chomp == 'no crontab for root'
    its(:stdout) { should match /MAILTO=rackspace-tickets@gooddata.com/ }
  end
end
