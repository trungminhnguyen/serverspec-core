def check_packages(packages, version)
  packages.each do |package|
    describe package(package) do
      it { should be_installed.with_version(version) }
    end
  end
end
