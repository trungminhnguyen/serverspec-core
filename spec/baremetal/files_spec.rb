require 'spec_helper'

# Files that should NOT be on host
[ '/root/.ssh/puppet_master',
  '/root/.ssh/config',
  '/etc/eyaml/keys/private_key.pkcs7.pem',
  '/etc/eyaml/keys/public_key.pkcs7.pem',
  '/etc/sysconfig/network-scripts/ifcfg-bond0.279',
  '/etc/sysconfig/network-scripts/ifcfg-bond1',
  '/etc/sysconfig/network-scripts/ifcfg-bond1.282',
  '/etc/pki/tls/private/cmdb.key',
  '/etc/opt/cloud/mysql_backup_password',
  '/root/.s3cfg',
  '/etc/opt/cloud/.s3cfg',
  '/root/.ssh/devcfg-backup',
  '/etc/pki/tls/private/auth-api.na.getgooddata.com-key.pem',
  '/etc/pki/tls/private/cloud-api.na.getgooddata.com-key.pem',
  '/etc/pki/tls/private/image-api.na.getgooddata.com-key.pem',
  '/etc/pki/tls/private/ez-prod.na.getgooddata.com-key.pem',
  '/etc/nova/nova.conf'
].each do |f|
  describe file(f) do
    it { should_not be_file }
  end
end

describe file('/etc/opt/gdc/cred/ic2.url') do
  its(:content) { should eq "https://<user>:<password>@ic2-api.gooddata.com\n"}
end

describe file('/etc/opt/cloud/backup-ng.key') do
  its(:content) { should eq '' }
end

f_exp = 'ListenAddress 172\.30\.64\.(108|109|110|111|112)
Protocol 2

SyslogFacility AUTHPRIV

PasswordAuthentication yes
ChallengeResponseAuthentication no

GSSAPIAuthentication yes
GSSAPICleanupCredentials yes

UsePAM yes

AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

Subsystem   sftp    \/usr\/libexec\/openssh\/sftp-server'

describe file('/etc/ssh/sshd_config') do
  its(:content) { should match Regexp.new(f_exp) }
end

f_bond0 = 'DEVICE=bond0
ONBOOT=yes
PRIMARY=p4p1
BONDING_OPTS=\"miimon=300 mode=active-backup\"
BOOTPROTO=static
NETMASK=255.255.255.0
IPADDR=172.30.64.(108|109|110|111|112)
GATEWAY=172.30.64.1'

describe file('/etc/sysconfig/network-scripts/ifcfg-bond0') do
  its(:content) { should match Regexp.new(f_bond0) }
end

f_p4 = 'DEVICE=p4p2
NM_CONTROLLED=no
ONBOOT=no'

describe file('/etc/sysconfig/network-scripts/ifcfg-p4p2') do
  its(:content) { should match Regexp.new(f_p4) }
end

f_p5 = 'DEVICE=p5p2
NM_CONTROLLED=no
ONBOOT=no'

describe file('/etc/sysconfig/network-scripts/ifcfg-p5p2') do
  its(:content) { should match Regexp.new(f_p5) }
end
