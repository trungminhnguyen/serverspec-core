require 'spec_helper'

known_good_kernels = [
'3.10.12',                                                                      
'3.10.13',                                                                      
'3.10.14',                                                                      
'3.10.15',                                                                      
'3.10.17',                                                                      
'3.10.18',                                                                      
'3.10.19',                                                                      
'3.10.20',                                                                      
'3.10.21',                                                                      
'3.10.23',                                                                      
'3.10.25',                                                                      
'3.10.28',                                                                      
'3.10.30',                                                                      
'3.10.33',                                                                      
'3.10.34',                                                                      
'3.10.36',                                                                      
'3.12.16',                                                                      
'3.12.18',                                                                      
'3.12.19',                                                                      
'3.12.20',                                                                      
'3.12.21',                                                                      
'3.12.22',                                                                      
'3.12.22',                                                                      
'3.12.23',                                                                      
'3.12.27']

describe "safe kernel verion" do
  it "should be installed" do
    package('kernel-lt').should be_installed
    known_good_kernels.should include package('kernel-lt').version.version
  end
  it "should be currently running" do
    running_kernel = command('uname -r').stdout.chomp.gsub(/-.*/, '')
    known_good_kernels.should include running_kernel
  end

  it "should be only abailable in repositories" do
    last_available_kernel = command('yum --showduplicates list available kernel-lt|awk \'END{print $2}\'').stdout.
      chomp.gsub(/-.*/, '')
    
    known_good_kernels.should include last_available_kernel

  end
end
