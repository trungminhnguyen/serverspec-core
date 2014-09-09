require 'spec_helper'

describe file('/proc/cmdline') do
  its(:content) { should match /elevator=deadline intremap=no_x2apic_optout nomodeset video=efifb/ }
end
