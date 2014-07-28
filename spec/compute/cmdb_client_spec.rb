require 'spec_helper'

describe package('cmdb-client') do
    it { should be_installed }
end

describe service('cmdb-client') do
    it { should be_enabled }
    it { should be_running }
end

describe file('/etc/cmdb_client.json') do
    it { should be_file }
    its(:content) { should match /"api_endpoint": "https:\/\/cmdb.na.getgooddata.com\/api\/v1\/node\/"/ }
end
