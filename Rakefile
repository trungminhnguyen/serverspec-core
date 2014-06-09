require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

profiles = YAML.load_file('profiles.yml')

task :default => :spec

desc "Run serverspec to all hosts"
task :spec => 'serverspec:all'

namespace :serverspec do
  task :all => profiles.keys.map {|key| 'serverspec:' + key.split('.')[0] }
  profiles.keys.each do |key|
    desc "Run serverspec to #{key}"
    RSpec::Core::RakeTask.new(key.split('.')[0].to_sym) do |t|
      ENV['TARGET_HOST'] = key
      t.pattern = 'spec/{' + profiles[key][:roles].join(',') + '}/*_spec.rb'
    end
  end
end
