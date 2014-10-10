require 'spec_helper'

describe "PCI-4162" do
  it 'check for SED drives' do
   encrypted = command(%q{omreport storage pdisk controller=0 | awk '$1 == "Encrypted"'}).stdout
   encrypted = encrypted.split.uniq.join
   expect(encrypted).to eq 'Encrypted:Yes'
  end
end
