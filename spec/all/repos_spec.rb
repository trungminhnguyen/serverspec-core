require 'spec_helper'

# Checking url correctness for all enabled repos. 
# We are intentionally ignoring dell's omsa repo

excluded_repos = 'dell\|folsom' # the ones that we don't check
disabled_repos = 'gdc-tools-testing' # the ones we check for url but they should be disabled

describe command("yum repolist enabled --verbose| grep baseurl | sort | grep -v '#{excluded_repos}' | sed 's:/$::g'") do
  its(:stdout) { should eq "Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/cure-puppet
Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/epel/6/x86_64
Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/gdc_tools/centos/6/x86_64
Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/sl/#{os[:release]}/x86_64/os
Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/sl/#{os[:release]}/x86_64/security
" }
end

describe command("yum repolist disabled --verbose | grep baseurl | sort | grep '#{disabled_repos}'") do
  its(:stdout) { should eq "Repo-baseurl : http://mgmt-repo02.int.na.getgooddata.com:8080/pulp/repos/gdc-tools-testing/centos/6/x86_64/
" }
end
