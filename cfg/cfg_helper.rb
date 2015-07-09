require 'parseconfig'

def get_environment
  return ENV['SERVERSPEC_ENV'] ||
              ParseConfig.new('/etc/puppet/puppet.conf')['main']['environment']
end

def get_main_config(conf_dir='./cfg/')
  conf_dir = get_config_option('CONF_DIR', conf_dir)
  return YAML.load_file "#{conf_dir}/serverspec.yml"
end

def get_all_hosts(conf_dir='./cfg/')
  env = get_environment()
  conf_dir = get_config_option('CONF_DIR', conf_dir)
  config = get_main_config(conf_dir)
  @hosts = File.join(conf_dir, config[env][:hosts])
  return YAML.load_file(ENV['HOSTS'] || @hosts)
end

def get_config_option(variable, default)
  sysconfig_file = '/etc/sysconfig/serverspec'
  return ENV[variable] ||
    (ParseConfig.new(sysconfig_file)[variable] if File.readable?(sysconfig_file)) ||
    default
end
