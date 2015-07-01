%global install_dir /opt/gdc/serverspec-core

Name:             serverspec-core
Summary:          GoodData ServerSpec integration
Version:          1.0
Release:          6.gdc

Vendor:           GoodData
Group:            GoodData/Tools

License:          Gooddata proprietary
URL:              https://github.com/gooddata/serverspec-core
Source0:          sources.tar
BuildArch:        noarch
BuildRoot:        %{_tmppath}/%{name}-%{version}-root

Requires:         ruby193-rubygem-rake
Requires:         ruby193-rubygem-serverspec
Requires:         ruby193-rubygem-colorize
Requires:         ruby193-rubygem-parseconfig

%prep
%setup -q -c

%install
rm -fr $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{install_dir}
cp -a * $RPM_BUILD_ROOT%{install_dir}
install -d $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/
mv $RPM_BUILD_ROOT%{install_dir}/serverspec.sysconfig $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/serverspec

%clean
rm -rf $RPM_BUILD_ROOT

%description
GoodData ServerSpec integration - core package

%files
%attr(0755, root, root) %dir %{install_dir}
%attr(0755, root, root) %dir %{install_dir}/cfg
%attr(0755, root, root) %dir %{install_dir}/spec
%attr(0755, root, root) %{install_dir}/spec/types
%attr(0755, root, root) %{install_dir}/cfg/cfg_helper.rb
%attr(0755, root, root) %{install_dir}/check_last_run.sh
%attr(0755, root, root) %{install_dir}/cron_run.sh
%attr(0755, root, root) %{install_dir}/Rakefile
%attr(0755, root, root) %{install_dir}/serverspec-core.spec
%attr(0755, root, root) %{install_dir}/spec/spec_helper.rb
%attr(0755, root, root) %doc %{install_dir}/*.md
%attr(0644, root, root) %config(noreplace) %{_sysconfdir}/sysconfig/serverspec
%exclude %{install_dir}/Gemfile*
%exclude %{install_dir}/Makefile
%exclude %{install_dir}/makemeusable


%changelog
* Wed Jul 01 2015 Martin Surovcak <martin.surovcak@gooddata.com> 1.0-6.gdc
- cron should not exec bundle anymore

* Mon Jun 29 2015 Radek Smidl <radek.smidl@gooddata.com> 1.0-5.gdc
- REPORTS_PATH renamed to REPORTS_DIR

* Mon Jun 29 2015 Radek Smidl <radek.smidl@gooddata.com> 1.0-4.gdc
- CONF_DIR and SPEC_DIR options added

* Mon Jun 29 2015 Radek Smidl <radek.smidl@gooddata.com> 1.0-3.gdc
- sysconfig support added

* Wed Jun 10 2015 Yury Tsarev <yury.tsarev@gooddata.com> 1.0-2.gdc
- Fix versioning and file inclusion

* Tue Jun 09 2015 Martin Surovcak <martin.surovcak@gooddata.com> 1.0-1.gdc
- Initial rpmbuild
