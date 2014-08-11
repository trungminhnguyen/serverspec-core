require 'spec_helper'

describe package('kernel-lt') do
  it            { should be_installed }
  its(:version) { should < '3.12.23' }
end

describe command('uname -r') do
  its(:stdout) { should < '3.12.23' }
end

describe command('yum --showduplicates list available kernel-lt|awk \'END{print $2}\'') do
  its(:stdout) { should < '3.12.23' }
end
