# encoding: utf-8
require 'rake'
require 'rspec/core/rake_task'
require 'colorize'
require 'json'
require 'yaml'
require 'net/http'
require 'uri'
require 'parseconfig'
require './cfg/cfg_helper'

conf_dir = './cfg/'
# Env is inherited from puppet config or overrided by env variable
env = get_environment
config = get_main_config(conf_dir)
@suites = config[env][:suites] # Test suites to use for env
@@reports  = './reports'         # Where to store JSON reports
@@exit_status = 0 # Overall test run exist status

# Special version of RakeTask for serverspec which comes with better
# reporting
class ServerspecTask < RSpec::Core::RakeTask
  attr_accessor :target
  attr_accessor :tags

  # Run our serverspec task. Errors are ignored.
  def run_task(verbose)
    json = "#{@@reports}/current/#{target}.json"
    @rspec_opts = ['--format', 'json', '--out', json]
    if ENV['SERVERSPEC_BACKEND'] == 'exec'
      @rspec_opts += ['--format', 'progress']
    else
      @rspec_opts += ['-c']
    end
    system("env TARGET_HOST=#{target} TARGET_TAGS=#{(tags || [])
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
      @@exit_status = 1
    else
      print "[OK /#{total} ] ".green, target, "\n"
    end
    rescue => e
      print '[ERROR   ] '.red, target, " (#{e.message})", "\n"
      @@exit_status = 1
  end
end

hosts = get_all_hosts(conf_dir)

desc 'Run serverspec to all hosts'
task spec: 'check:server:all'

namespace :check do

  # Per server tasks
  namespace :server do
    desc 'Run serverspec to all hosts'
    unless ENV['SERVERSPEC_BACKEND'] == 'exec'
      hosts.delete_if do |hostname, host|
        host[:tags] and host[:tags].include? 'localhost_only'
      end
    end
    task all: hosts.keys.map { |h| h }
    hosts.each do |hostname, host|
      desc "Run serverspec to host #{hostname}"
      ServerspecTask.new(hostname.to_sym) do |t|
        dirs = ['all'] + host[:roles] + [hostname]
        t.target = hostname
        t.tags = host[:tags]
        t.pattern = './spec/{' + @suites.join(',') + '}/{' + dirs.join(',') + '}/*_spec.rb'
      end
    end
  end

  # Per role tasks
  namespace :role do
    roles = hosts.each.map { |_k, h| h[:roles] }
    roles = roles.flatten.uniq
    roles.each do |role|
      desc "Run serverspec to role #{role}"
      task "#{role}" => hosts.select { |_hostname, h| h[:roles].include? role }
        .map do
          |hostname, _h| 'check:server:' + hostname
        end
    end
  end
end

namespace :reports do
  desc 'Clean up old partial reports'
  task :clean do
    FileUtils.rm_rf "#{@@reports}/current"
  end

  desc 'Clean reports without results'
  task :housekeep do
    files = FileList.new("#{@@reports}/*.json").map do |f|
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
    FileList.new("#{@@reports}/*.json").each do |f|
      system 'gzip', f
    end
  end
  task gzip: 'housekeep'

  desc 'Build final report'
  task :build, :tasks do |_t, args|
    args.with_defaults(tasks: ['unspecified'])
    now = Time.now
    fname = format("#{@@reports}/%s--%s.json",
                   args[:tasks].join('-'), now.strftime('%Y-%m-%dT%H:%M:%S'))
    File.open(fname, 'w') do |f|
      # Test results
      tests = FileList.new("#{@@reports}/current/*.json").sort.map do |j|
        content = File.read(j).strip
        {
          hostname: File.basename(j, '.json'),
          results: JSON.parse(content.empty? ? '{}' : content)
        }
      end.to_a
      # Relevant source files
      sources = FileList.new("#{@@reports}/current/*.json").sort.map do |j|
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
      exit @@exit_status
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
  task.start_with?('check:') || task == 'spec'
end
unless running_check_tasks.empty?
  Rake::Task[running_check_tasks.last].enhance do
    Rake::Task['reports:build'].invoke(running_check_tasks)
  end
  running_check_tasks.each do |t|
    task 'reports:build' => t
  end
end
