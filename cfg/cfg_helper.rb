require 'parseconfig'
require 'yaml'

def get_environment
  env = ENV['SERVERSPEC_ENV'] ||
              ParseConfig.new('/etc/puppet/puppet.conf')['main']['environment']
  raise "Environment is not detected, try to set SERVERSPEC_ENV variable..." if env.nil?
  env
end

def get_main_config(conf_dir='./cfg/', env)
  conf_dir = get_config_option('CONF_DIR', conf_dir)
  config = YAML.load_file "#{conf_dir}/serverspec.yml"
  raise "Can't find #{env} environment definition in serverspec.yml" unless config[env]
  config[env]
end

def get_all_hosts(conf_dir='./cfg/')
  env = get_environment
  conf_dir = get_config_option('CONF_DIR', conf_dir)
  config = get_main_config(conf_dir, env)
  @hosts = File.join(conf_dir, config[:hosts])
  return YAML.load_file(ENV['HOSTS'] || @hosts)
end

def get_config_option(variable, default)
  sysconfig_file = '/etc/sysconfig/serverspec'
  return ENV[variable] ||
    (ParseConfig.new(sysconfig_file)[variable] if File.readable?(sysconfig_file)) ||
    default
end
