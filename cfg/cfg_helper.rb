require 'parseconfig'

def get_environment
  return ENV['SERVERSPEC_ENV'] ||
              ParseConfig.new('/etc/puppet/puppet.conf')['main']['environment']
end

def get_main_config(conf_dir='./cfg/')
  return YAML.load_file "#{conf_dir}/serverspec.yml"
end

def get_all_hosts(conf_dir='./cfg/')
  env = get_environment()
  config = get_main_config(conf_dir)
  @hosts = conf_dir + config[env][:hosts]
  return YAML.load_file(ENV['HOSTS'] || @hosts)
end
