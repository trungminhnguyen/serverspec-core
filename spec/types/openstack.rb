module Serverspec
  module Type

    class Openstack < Base

      def with_local_ebs?
        ret = @runner.run_command('pgrep tgtd | wc -l')
        ret = ret.stdout.to_i
        ret == 2
      end

    end

    def openstack
      Openstack.new
    end
  end
end
