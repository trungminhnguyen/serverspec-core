require 'spec_helper'

# MySQL (mysql::init)
describe service('common-mysqld') do
  it { should be_running }
  it { should be_enabled }
end

describe service('mysql') do
  it { should be_monitored_by('monit') }
end

describe 'mysql should listen on internal only' do
    describe port(3306) do
      it { should be_listening }
    end

    describe host('mgmt-backend01.na.getgooddata.com') do
      it { should_not be_reachable.with( :port => 3306 )}
    end

    describe host('mgmt-backend01.int.na.getgooddata.com') do
      it { should be_reachable.with( :port => 3306 )}
    end
end

# Backups (mysql::backup)
describe cron do
  it { should have_entry '0 11 * * * /opt/cloud/bin/backup-mysql.sh 2>&1 >> /var/log/mysql_backup' }
end

# Check already existing backup
# TODO: better regexp
describe command('s3cmd ls s3://gdc-openstack-backup') do
  its(:stdout) { should match Regexp.new('2014-07-14 09:20  15945120   s3://gdc-openstack-backup/openstack_db_backup_20140714-112002.sql.gze') }
end
