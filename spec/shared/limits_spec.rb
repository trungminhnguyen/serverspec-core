require 'spec_helper'

def check_limits(pidfile, snproc, snofile, hnofile)
  if command("test -f #{pidfile}").exit_status == 0
    describe command("cat /proc/$(cat #{pidfile})/limits") do
      it { should return_stdout /Max open files\s+#{snofile}\s+#{hnofile}\s+files/}
      it { should return_stdout /Max processes\s+#{snproc}\s+\d+\s+processes/}
    end
  end
end
