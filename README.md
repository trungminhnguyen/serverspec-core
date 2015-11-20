Serverspec Test Suite
=====================

This is an example of use of [serverspec][] with the following
additions:

 - host groups with a function classifier
 - parallel execution using a process pool
 - report generation (in JSON format)
 - report viewer

[serverspec]: http://serverspec.org/

First steps
-----------

Before using this example, you must provide your list of hosts in a
file named `hosts.yml`.

    dev-cmp04.int.na.getgooddata.com:
      :roles:
        - compute
        - dev
      :labels:
        - na

To install the dependencies, use `bundle install`.

You can then run a test session:

    $ bundle exec rake spec

It is possible to only run tests on some hosts or to restrict to some
roles:

    $ bundle exec rake check:role:compute
    $ bundle exec rake check:server:dev-cmp04.int.na.getgooddata.com

Also note that `sudo` is disabled in `spec/spec_helper.rb`. You can
enable it globally or locally, like explained [here][1].

[1]: http://serverspec.org/advanced_tips.html

JUnit output
------------
To create junit compatible reports together with json one use

    $ rake spec junit=true

it will create additional xml report under `reports/current/`

Custom output
-------------

To customize the type and verbosity of test results you can use
[rspec compatible fomatters][2], e.g.

    $ rake spec format=documentation

[2]: http://www.rubydoc.info/gems/rspec-core/RSpec/Core/Formatters

RSpec tag filtering
-------------------
If you use generic rspec tags in your specs e.g.

``` ruby
describe file('/etc/hosts'), :skip_in_kitchen do
   it { should be_file }
   it { should be_readable }
end
```

and want to filter them out use the following format.

To include :skip_in_kitchen tag run

    $ rake spec tag=not_in_kitchen

To exclude :skip_in_kitchen tag run the same but with tilde

    $ rake spec tag=~skip_in_kitchen

Classifier
----------

A role is just a string in :roles: array that should also be
a subdirectory in the `spec/` directory.
In this subdirectory, you can put any test that should be
run for the given role. Here is a simple example of a directory
structure for three roles:

    spec
    ├── all
    │   ├── lldpd_spec.rb
    │   └── network_spec.rb
    ├── memcache
    │   └── memcached_spec.rb
    └── web
        └── apache2_spec.rb

Moreover, there is optional :labels: array in definition whose purpose
is to attach labels to tests. Those labels are then made available for conditional
tests. You can do something like this with them:

    describe file('/data/images'), :label => "eu" do
      it { should be_mounted.with( :type => 'nfs' ) }
    end

This test will only be executed if `eu` is one of the labels of the
current host.

Helpers
-------

When it comes to run tests, the default `spec_helper` is used to "run tests", it
is possible to create custom helpers. This allows possibility to extend your
specs with custom helpers - eg. common functions.

Default `spec_helper` parse all helpers with path `SPEC_DIR/*/*_helper.rb`.

When creating helpers it is desired to add tests also, every file ending
`_test.rb` in `spec/helper` will be run when `serverspec-core selfcheck` is
invoked.

Types
-----

It is possible to build custom [Resource types][rtypes], they should be placed
in `spec/types/directory`. There are two `spec/types` locations, both can contain
types, but should be used differently:
 - `SPEC_DIR/types` is a place for types which goes with custom specs
 - `/opt/gdc/serverspec-core/spec/types` should contain types delivered via packages

It is also possible to create custom helper which will include custom types from
any other location.

[rtypes]: http://serverspec.org/resource_types.html

Style check with RuboCop
------------------------
To check style of your specs just run

    $ rake rubocop

You can even perform autocorrect with

    $ rake rubocop:auto_correct

It will try to fix the offenses automatically and report.
After that you can review the fixes and commit them into repository.

For details on RuboCop project see https://github.com/bbatsov/rubocop

Parallel execution
------------------

With many hosts and many tests, serial execution can take some
time. By using a pool of processes to run tests, it is possible to
speed up test execution. `rake` comes with builtin support of such
feature. Just execute it with `-j 10 -m`.

Reports
-------

Reports are automatically generated and put in `reports/` directory in
JSON format. They can be examined with a simple HTML viewer provided
in `viewer/` directory. Provide a report and you will get a grid view
of tests executed succesfully or not. By clicking on one result,
you'll get details of what happened, including the backtrace if any.

There is a task `reports:gzip` which will gzip reports (and remove
empty ones). To be able to still use them without manual unzip, you
need a configuration like this in nginx to be able to serve them:

    server {
       listen 80;
       server_name serverspec.example.com;
    
       location / {
          index index.html;
          root /path/to/serverspec/repo/viewer;
       }
       location /reports {
          autoindex on;
          root /path/to/serverspec/repo;
          gzip_static always;
          gzip_http_version 1.0;
          gunzip on;
       }
    }

If your version of nginx does not support `gunzip on`, you will
usually be fine without it...
