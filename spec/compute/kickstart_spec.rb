require 'spec_helper'

describe command('echo $LANG') do
  it {should return_stdout 'en_US.UTF-8'}
end

describe selinux do
    it { should be_permissive }
end

# Packages

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
gnupg2
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

# Repos

os = backend(Serverspec::Commands::Base).check_os
repos = "epel
gdc
3rdparty
sl"

repos.split.each do |repo|
  describe yumrepo(repo) do
      it { should be_enabled }
  end
end

# Services

enabled_services='network
sshd
ntpd
ntpdate
rsyslog
restorecond
monit
libvirtd
netfs
rpcbind
rpcidmapd'

enabled_services.split.each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

disabled_services='rpcgssd
cups
autofs
xinetd
libvirt-guests'

describe service 'nfslock' do
  it { should_not be_enabled }
  it { should be_running }
end

disabled_services.split.each do |service|
  describe service(service) do
    it { should_not be_enabled }
    it { should_not be_running }    
  end
end

monitored_services='libvirtd'

monitored_services.split.each do |service|
  describe service(service) do
    it { should be_monitored_by('monit') }
  end
end

# Networking

describe host('deploy.na.getgooddata.com') do
  # ping
   it { should be_reachable }
end

describe interface('bond0.279') do
  its(:speed) { should eq 10000 }
end

describe interface('bond1.282') do
  its(:speed) { should eq 10000 }
end

# Paritioning

# There is a cleaner way, but it's buggy
# Issue reported upstream https://github.com/serverspec/serverspec/issues/430
describe command('mount | grep /dev/mapper/nova--volumes-nova--instances') do
  it { should return_stdout '/dev/mapper/nova--volumes-nova--instances on /var/lib/nova type ext4 (rw,noatime)' }
end

describe command('lvscan|grep nova-instances') do
  it { should return_stdout /ACTIVE\s*'\/dev\/nova-volumes\/nova-instances'\s\[\d{2}\.\d{2} GiB\]\sinherit/ }
end

partitions='/
/boot
/boot/efi
/home
/var
/var/log'

partitions.split.each do |partition|
  describe file(partition) do
    it { should be_mounted }
  end
end

# Swap size check
describe 'swapsize' do
  it 'should be big enough' do
    swapsize = command("free -m|tail -1| awk '{print $2}'").stdout.to_i
    swapsize.should >= 4096
  end
end

# Maintenance user(s)
describe file('/root/.ssh') do
    it { should be_directory }
    it { should be_mode 700 }
end

# OS tweaks
describe 'Linux kernel parameters' do
  # Check if correct options are in action
  context linux_kernel_parameter('vm.swappiness') do
    its(:value) { should eq 10 }
  end
  context linux_kernel_parameter('vm.dirty_expire_centisecs') do
    its(:value) { should eq 3000 }
  end
  context linux_kernel_parameter('vm.dirty_ratio') do
    its(:value) { should eq 12 }
  end
  context linux_kernel_parameter('vm.dirty_writeback_centisecs') do
    its(:value) { should eq 500 }
  end
  context linux_kernel_parameter('vm.dirty_background_ratio') do
    its(:value) { should eq 3 }
  end
  context linux_kernel_parameter('kernel.sem') do
    its(:value) { should eq "500\t256000\t250\t1024" }
  end
  context linux_kernel_parameter('net.ipv4.ip_local_port_range') do
    its(:value) { should eq "30000\t65000" }
  end
  context linux_kernel_parameter('net.ipv4.ip_forward') do
    its(:value) { should eq 1 }
  end

  # Check if correct options are specified in sysctl.d files
  # Pay attention to ^ and $ in regexps
  describe file('/etc/sysctl.d/vm') do
    sysctl_options = '^vm.swappiness \= 10$
^vm.dirty_expire_centisecs \= 3000$
^vm.dirty_ratio \= 12$
^vm.dirty_writeback_centisecs \= 500$
^vm.dirty_background_ratio \= 3$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/semaphores') do
    sysctl_options = '^kernel.sem \= 500 256000 250 1024$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/bridge_iptables') do
    sysctl_options = '^net.bridge.bridge-nf-call-ip6tables \= 1$
^net.bridge.bridge-nf-call-iptables \= 1$
^net.bridge.bridge-nf-call-arptables \= 1$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end

  describe file('/etc/sysctl.d/net') do
    sysctl_options = 'net.ipv4.ip_local_port_range \= 30000 65000$
^net.ipv4.ip_forward \= 1$'
    sysctl_options.split.each do |option|
      its(:content) { should match Regexp.new(option) }
    end
  end
end

#resolv.conf

resolv_conf='domain na.getgooddata.com
search na.getgooddata.com getgooddata.com gooddata.com
nameserver 173.203.4.8
nameserver 173.203.4.9
nameserver 8.8.8.8
nameserver 8.8.4.4'

describe file('/etc/resolv.conf') do
  its(:content) {should match resolv_conf}
end

describe 'conntrack' do
  conntrack_conf='install nf_conntrack /sbin/modprobe --ignore-install nf_conntrack; sysctl -w net.netfilter.nf_conntrack_max=655360
install nf_conntrack_ipv4 /sbin/modprobe --ignore-install nf_conntrack_ipv4; sysctl -w net.netfilter.nf_conntrack_max=655360
options nf_conntrack hashsize=163840'

  describe file('/etc/modprobe.d/conntrack.conf') do
      its(:content) { should match conntrack_conf }
  end
  context linux_kernel_parameter('net.netfilter.nf_conntrack_max') do
    its(:value) { should eq 655360 }
  end
  describe kernel_module('nf_conntrack') do
    it { should be_loaded}
  end
end

describe file('/proc/cmdline') do
  its(:content) { should match /elevator=deadline intremap=no_x2apic_optout nomodeset video=efifb/ }
end

describe 'encryption', tag: 'crypt' do
  it 'should have 256 keysize' do
    keysizes = command("ls -1 /dev/mapper/luks-* | xargs -n1 cryptsetup status|grep keysize| awk '{print $2}'").stdout
    keysizes.should_not be_empty
    keysizes.split.each do |keysize| 
      keysize.to_i.should eq 256
    end
  end

  describe file('/boot') do
    it { should be_mounted.with( :type => 'ext4' ) }
  end
  describe file('/boot/efi') do
    it { should be_mounted.with( :type => 'vfat' ) }
  end

  it 'has all physical partitions except /boot and /boot/efi are encrypted' do
    crypts = command("blkid | grep \/sd|tail -n +3|awk '{print $3}'").stdout
    crypts.split.length.should > 0
    crypts.split.each do |type|
      type.should == 'TYPE="crypto_LUKS"'
    end
  end
end
