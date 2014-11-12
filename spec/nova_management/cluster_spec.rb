require 'spec_helper'

describe command("clustat | awk '{print $1}'") do
  its(:stdout) { should eq "Cluster
Member

Member
------
mgmt04.ha.na.getgooddata.com
mgmt05.ha.na.getgooddata.com

Service
-------
service:libvirt_mgmt04
service:libvirt_mgmt05
service:storage_mgmt04
service:storage_mgmt05
vm:vm_apiproxy01
vm:vm_apiserver01
vm:vm_apiserver02
vm:vm_backend01
vm:vm_cmdb
vm:vm_deploy
vm:vm_glance01
vm:vm_netapp01
vm:vm_repo
vm:vm_repo02
vm:vm_serverspec
vm:vm_test01
" }
end
