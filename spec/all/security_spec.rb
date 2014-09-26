require 'spec_helper'

# http://lwn.net/Articles/613032/
# using command as serverspec verision method does not include release
describe command('rpm -q --queryformat "%{version}-%{release}" bash') do
  its(:stdout) { should eq '4.1.2-15.el6_5.2' }
end
