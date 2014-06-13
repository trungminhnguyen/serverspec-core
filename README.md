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
      :tags:
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

Moreover, there is optional :tags: array in definition whose purpose 
is to attach tags to tests. Those tags are then made available for conditional
tests. You can do something like this with them:

    describe file('/data/images'), :tag => "eu" do
      it { should be_mounted.with( :type => 'nfs' ) }
    end

This test will only be executed if `eu` is one of the tags of the
current host.

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
