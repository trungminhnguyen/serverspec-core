require 'spec_helper'

describe cron do
  it { should have_entry '0 11 * * * /opt/cloud/bin/backup-mysql.sh 2>&1 >> /var/log/mysql_backup' }
  it { should have_entry '0 2 * * * /usr/bin/keystone-manage token_flush &> /dev/null' }
  it { should have_entry '0 * * * * /opt/cloud/libexec/s3sync.sh 2>&1 > /dev/null' }
  it { should have_entry '12 17 * * * /opt/cloud/bin/bonzlist.sh' }
end

# Check already existing backup
# TODO: better regexp
describe command('s3cmd ls s3://gdc-openstack-backup') do
  its(:stdout) { should match Regexp.new('2014-07-14 09:20  15945120   s3://gdc-openstack-backup/openstack_db_backup_20140714-112002.sql.gze') }
end

describe command('s3cmd -c /etc/opt/cloud/.s3cfg ls s3://gdc-ms-int/AIDAITKADXPFIBCFHLOUS_gdc-ms-int_adwh/') do
  its(:stdout) { should match Regexp.new('s3://gdc-ms-int/AIDAITKADXPFIBCFHLOUS_gdc-ms-int_adwh/na-volumes.csv') }
end
