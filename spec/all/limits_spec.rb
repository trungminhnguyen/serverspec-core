require 'spec_helper'

snproc  = 4096
snofile = 4096
hnofile = 8192

describe 'PCI-3988 - limits' do
  pidfiles = ['/var/run/rabbitmq/pid','/var/run/nova/nova-scheduler.pid']
  pidfiles.each do |pidfile|
    if command("test -f #{pidfile}").exit_status == 0
      describe command("cat /proc/$(cat #{pidfile})/limits") do
        it { should return_stdout /Max open files\s+#{snofile}\s+#{hnofile}\s+files/}
        it { should return_stdout /Max processes\s+#{snproc}\s+\d+\s+processes/}
      end
    end
  end
end
