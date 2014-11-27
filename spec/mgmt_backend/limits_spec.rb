require 'spec_helper'

sched_snproc  = 4096
sched_snofile = 4096
sched_hnofile = 8192

describe 'scheduler - limits' do
  pidfile = ['/var/run/nova/nova-scheduler.pid']
  if command("test -f #{pidfile}").exit_status == 0
    describe command("cat /proc/$(cat #{pidfile})/limits") do
      it { should return_stdout /Max open files\s+#{sched_snofile}\s+#{sched_hnofile}\s+files/}
      it { should return_stdout /Max processes\s+#{sched_snproc}\s+\d+\s+processes/}
    end
  end
end

rabbit_snproc  = 4096
rabbit_snofile = 8192
rabbit_hnofile = 8192

describe 'rabbit - limits' do
  pidfile = ['/var/run/rabbitmq/pid']
  if command("test -f #{pidfile}").exit_status == 0
    describe command("cat /proc/$(cat #{pidfile})/limits") do
      it { should return_stdout /Max open files\s+#{rabbit_snofile}\s+#{rabbit_hnofile}\s+files/}
      it { should return_stdout /Max processes\s+#{rabbit_snproc}\s+\d+\s+processes/}
    end
  end
end
