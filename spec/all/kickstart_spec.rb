require 'spec_helper'

describe command('echo $LANG') do
  it {should return_stdout 'en_US.UTF-8'}
end

describe selinux do
    it { should be_permissive }
end

packages = 'xfsprogs
dosfstools
e2fsprogs
acl
attr
audit
authconfig
bind-utils
cyrus-sasl
cyrus-sasl-plain
db4-utils
ddclient
dstat
elinks
epel-release
ftp
hardlink
iotop
iptstate
logwatch
lsof
man-pages
mtr
net-snmp-utils
nss_db
nss-tools
numactl
openssh-server
parted
perl-Apache-DBI
perl-Archive-Tar
perl-Array-Utils
perl-Config-Tiny
perl-Crypt-SSLeay
perl-DateTime
perl-DBD-SQLite
perl-Devel-Cover
perl-IO-Socket-INET6
perl-JSON-XS
perl-Net-DNS
perl-Statistics-Descriptive
perl-Sub-Uplevel
perl-Sys-Statistics-Linux
perl-XML-XPath
perl-YAML
postfix
prelink
psacct
puppet
pv
python-simplejson
PyXML
rrdtool-perl
rsyslog-gnutls
screen
selinux-policy-targeted
strace
stunnel
sudo
symlinks
sysstat
tcpdump
tcsh
tmux
traceroute
tree
uuid-perl
vconfig
vim-enhanced
git
ntp
file
acpid
authconfig
blktrace
bridge-utils
dhclient
eject
fprintd-pam
gnupg
irqbalance
lvm2
microcode_ctl
mlocate
net-snmp
nss-pam-ldapd
pam_ldap
pam_passwdqc
perl-Algorithm-C3
procmail
quota
ntsysv
readahead
rng-tools
setserial
setuptool
smartmontools
tmpwatch
usbutils
yum-plugin-fastestmirror
yum-plugin-versionlock
yum-utils
man
man-pages-overrides
wget
biosdevname
oam-puppet-cloud
libvirt 
qemu-kvm
qemu-kvm-tools
sg3_utils
sdparm
lsscsi
spice-server
monit
virt-top
tunctl
htop
kernel-lt'

packages.split.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

not_installed_packages = 'atmel-firmware
b43-openfwwf
aic94xx-firmware
bfa-firmware
ipw2100-firmware
ipw2200-firmware
ivtv-firmware
iwl100-firmware
iwl1000-firmware
iwl3945-firmware
iwl4965-firmware
iwl5000-firmware
iwl5150-firmware
iwl6000-firmware
iwl6000g2a-firmware
iwl6000g2b-firmware
iwl6050-firmware
libertas-usb8388
netxen-firmware
ql2100-firmware
ql2200-firmware
ql23xx-firmware
ql2400-firmware
ql2500-firmware
rt61pci-firmware
rt73usb-firmware
xorg-x11-drv-ati-firmware
zd1211-firmware
kexec-tools
system-config-kdump'

not_installed_packages.split.each do |package|
  describe package(package) do
    it { should_not be_installed }
  end
end

os = backend(Serverspec::Commands::Base).check_os
repos = "epel
deployment-proxy
3rdparty
sl#{os[:release]}"

repos.split.each do |repo|
  describe yumrepo(repo) do
      it { should be_enabled }
  end
end
