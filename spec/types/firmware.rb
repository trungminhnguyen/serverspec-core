module Serverspec
  module Type

    class Firmware < Base

      def bios
        version_fetch('BIOS')
      end

      def idrac
        version_fetch('iDRAC7')
      end

      def lifecyclecontroller
        version_fetch('Lifecycle Controller')
      end

      def raid
        version_fetch('PERC H710')
      end

      def raid_model
        ret = @runner.run_command "omreport system version | awk '/PERC/ {print $4}'"
        ret.stdout.chomp
      end

      def nics
        active_nics = @runner.run_command("omreport chassis nics |grep -B 4 'Connection Status : Connected'|awk '/Index/ {print $3}'")
        active_nics = active_nics.stdout.split
        nic_versions = []
        active_nics.each do |index|
          version = @runner.run_command("omreport chassis nics index=#{index} | grep Firmware -A1 | tail -1 ")
          nic_versions << version.stdout.chomp
        end
        nic_versions
      end

      private

      def version_fetch(thing)
        ret = @runner.run_command "omreport system version | grep '#{thing}' -A1|tail -1 | awk '{print $3}'"
        ret.stdout.chomp
      end

    end

    def firmware
      Firmware.new
    end

  end
end
