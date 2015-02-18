module Serverspec
  module Type
    class Bios < Base

      def correct?
        if ret.match /FAIL/
          false
        else
          true
        end
      end

      def with_internal_network?
        if (ret.scan("FAIL").count == 1 and 
          ret.match /\[ FAIL \] IntegratedNetwork1 should be\/is: DisabledOs \/ Enabled/)
          true
        else
          false
        end
      end

      def stdout
        ret
      end

      private

      def ret
        ret = backend.run_command('/opt/cloud/bin/check_bios.sh -r')
        ret = ret.stdout.chomp
      end

    end

    def bios
      Bios.new
    end

  end
end
