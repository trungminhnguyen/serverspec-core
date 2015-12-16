# encoding: utf-8
require 'rake'
require 'rspec/core/rake_task'
require 'colorize'
require 'json'
require 'yaml'
require 'net/http'
require 'uri'
require 'parseconfig'
require 'rubocop'
require 'rubocop/rake_task'
require 'rubocop-junit-formatter'
require './cfg/cfg_helper'

conf_dir = get_config_option('CONF_DIR', './cfg/')
# Env is inherited from puppet config or overrided by env variable
env = get_environment
config = get_main_config(conf_dir, env)
@suites = config[:suites] # Test suites to use for env
REPORTS = get_config_option('REPORTS_DIR', './reports') # Where to store JSON reports
SPEC_DIR = get_config_option('SPEC_DIR', './spec') # Where to store JSON specs

class ExitStatus
  def self.code=(x)
    @code = x
  end
  def self.code
    @code ||= 0
  end
end

# Special version of RakeTask for serverspec which comes with better
# reporting
class ServerspecTask < RSpec::Core::RakeTask
  attr_accessor :target
  attr_accessor :labels

  # Run our serverspec task. Errors are ignored.
  def run_task(verbose)
    json = "#{REPORTS}/current/#{target}.json"
    @rspec_opts = ['--format', 'json', '--out', json]
    if ENV['junit']
      junit = "#{REPORTS}/current/#{target}.xml"
      @rspec_opts += ['--format', 'RspecJunitFormatter', '--out', junit]
    end
    @rspec_opts += ['--format', ENV['format']] if ENV['format']
    @rspec_opts += ['--tag', ENV['tag']] if ENV['tag']
    if ENV['SERVERSPEC_BACKEND'] == 'exec'
      @rspec_opts += ['--format', 'progress']
    else
      @rspec_opts += ['-c']
    end
    system("env TARGET_HOST=#{target} TARGET_LABELS=#{(labels || [])
           .join(',')} #{spec_command}")
    status(target, json) if verbose
  end

  # Display status of a test from its JSON output
  def status(target, json)
    out = JSON.parse(File.read(json))
    summary = out['summary']
    total = summary['example_count']
    failures = summary['failure_count']
    if failures > 0
      print format('[%-3s/%-4s] ', failures, total).yellow, target, "\n"
      ExitStatus.code = 1
    else
      print "[OK /#{total} ] ".green, target, "\n"
    end
    rescue => e
      print '[ERROR   ] '.red, target, " (#{e.message})", "\n"
      ExitStatus.code = 1
  end
end

hosts = get_all_hosts(conf_dir)

task default: :spec

desc 'Run serverspec to all hosts'
task spec: 'check:server:all'

desc 'Run RuboCop over your fancy specs'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = [SPEC_DIR + '/**/*.rb']
  if ENV['junit']
    # https://github.com/bbatsov/rubocop/issues/1584
    formatter = 'RuboCop::Formatter::JUnitFormatter'
  else
    formatter = 'progress'
  end
  task.formatters = [ formatter ]
end

desc 'Run selfchecks for your specs in *_test.rb'
RSpec::Core::RakeTask.new(:selfcheck) do |t|
  t.pattern = [ SPEC_DIR + '/**/*_test.rb', './spec/**/*_test.rb']
end

namespace :check do

  # Per server tasks
  namespace :server do
    desc 'Run serverspec to all hosts'
    unless ENV['SERVERSPEC_BACKEND'] == 'exec'
      hosts.delete_if do |hostname, host|
        host[:labels] and host[:labels].include? 'localhost_only'
      end
    end
    task all: hosts.keys.map { |h| h }
    hosts.each do |hostname, host|
      desc "Run serverspec to host #{hostname}"
      ServerspecTask.new(hostname.to_sym) do |t|
        dirs = ['all'] + host[:roles] + [hostname]
        t.target = hostname
        t.labels = host[:labels]
        t.pattern = "#{SPEC_DIR}/{" + @suites.join(',') + '}/{' + dirs.join(',') + '}/*_spec.rb'
      end
    end
  end

  # Per role tasks
  namespace :role do
    roles = hosts.each.map { |_k, h| h[:roles] }
    roles = roles.flatten.uniq
    roles.each do |role|
      desc "Run serverspec to role #{role}"
      task "#{role}" => hosts.select { |_hostname, h| h[:roles].to_a.include? role }
        .map do
          |hostname, _h| 'check:server:' + hostname
        end
    end
  end
end

namespace :reports do
  desc 'Clean up old partial reports'
  task :clean do
    FileUtils.rm_rf "#{REPORTS}/current"
  end

  desc 'Clean reports without results'
  task :housekeep do
    files = FileList.new("#{REPORTS}/*.json").map do |f|
      content = File.read(f)
      if content.empty?
        # No content, let's remove it
        f
      else
        results = JSON.parse(content)
        if !results.include?('tests') || results['tests'].map do |t|
          if t.include?('results') &&
            t['results'].include?('examples') &&
              !t['results']['examples'].empty?
            t
          end
        end.compact.empty?
          f
        end
      end
    end
    files.compact.each do |f|
      FileUtils.rm f
    end
  end

  desc 'Gzip all reports'
  task :gzip do
    FileList.new("#{REPORTS}/*.json").each do |f|
      system 'gzip', f
    end
  end
  task gzip: 'housekeep'

  desc 'Build final report'
  task :build, :tasks do |_t, args|
    args.with_defaults(tasks: ['unspecified'])
    now = Time.now
    fname = format("#{REPORTS}/%s--%s.json",
                   args[:tasks].join('-'), now.strftime('%Y-%m-%dT%H:%M:%S'))
    File.open(fname, 'w') do |f|
      # Test results
      tests = FileList.new("#{REPORTS}/current/*.json").sort.map do |j|
        content = File.read(j).strip
        {
          hostname: File.basename(j, '.json'),
          results: JSON.parse(content.empty? ? '{}' : content)
        }
      end.to_a
      # Relevant source files
      sources = FileList.new("#{REPORTS}/current/*.json").sort.map do |j|
        content = File.read(j).strip
        results = JSON.parse(
                      content.empty? ? '{"examples": []}' : content)['examples']
        results.map { |r| r['file_path'] }
      end.to_a.flatten(1).uniq
      sources = sources.each_with_object(Hash.new) do |file, h|
        h[file] = File.readlines(file).map { |l| l.chomp }.to_a
      end
      json_hash = { version: 1,
                    tests: tests,
                    sources: sources }
      f.puts JSON.generate(json_hash)
      f.close
      uri = URI.parse "http://localhost/#{File.basename(fname)}"
      # Report precache
      begin
        response = Net::HTTP.get_response(uri).code
      rescue
      end
      exit ExitStatus.code
    end
  end
end

# Before starting any task, cleanup reports
all_check_tasks = Rake.application.tasks.select do |task|
  task.name.start_with?('check:')
end
all_check_tasks.each do |t|
  t.enhance ['reports:clean']
end

# Build final report only after last check
running_check_tasks = Rake.application.top_level_tasks.select do |task|
  task.start_with?('check:') || ['spec', 'default'].include?(task)
end
unless running_check_tasks.empty?
  Rake::Task[running_check_tasks.last].enhance do
    Rake::Task['reports:build'].invoke(running_check_tasks)
  end
  running_check_tasks.each do |t|
    task 'reports:build' => t
  end
end
