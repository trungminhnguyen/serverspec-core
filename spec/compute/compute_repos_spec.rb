require 'spec_helper'

# Here we are checking only repositories specific to compute role
# The rest is checked in 'all' role

expected_repos = 'folsom'

describe command("yum repolist enabled --verbose| grep baseurl | sort | grep '#{expected_repos}'") do
  its(:stdout) { should eq "Repo-baseurl : http://repos.fedorapeople.org/repos/openstack/EOL/openstack-folsom/epel-6/
" }
end
