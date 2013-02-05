#
# Cookbook Name:: localshop
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'securerandom'

unless node['localshop']['secret_key']
  node.set['localshop']['secret_key'] = SecureRandom.uuid
end

package 'git'

user node['localshop']['user']
group node['localshop']['group']

localshop_env = {
  'LOCALSHOP_HOME' => ::File.join(node['localshop']['dir'],'shared')
}

venv = ::File.join(node['localshop']['dir'],'shared','env')
venv_python = ::File.join(venv,'bin','python')

%w{ config packages }.each do |dirname|
  directory ::File.join(node['localshop']['dir'],'shared',dirname) do
    owner node['localshop']['user']
    group node['localshop']['group']
    mode 00750
    recursive true
    action :create
  end
end

application 'localshop' do
  path node['localshop']['dir']
  owner node['localshop']['user']
  group node['localshop']['group']
  repository node['localshop']['repository']
  revision node['localshop']['revision']
  migrate true
  packages []
  symlinks({
    'packages' => 'source',
    'localshop.conf.py' => 'localshop.conf.py'
  })

  django do
    local_settings_file 'localshop.conf.py'
    settings_template 'localshop.conf.py.erb'
    migration_command "#{venv_python} manage.py syncdb --noinput && #{venv_python} manage.py migrate"
  end

  gunicorn do
    app_module :django
    virtualenv venv
    environment(localshop_env)
  end

  celery do
    config 'celery_settings.py'
    django true
    celeryd true
    broker do
      host 'localhost'
    end
  end

end

cookbook_file '/usr/local/bin/runinenv' do
  source 'runinenv.sh'
  mode 0755
end

execute "initalize localshop" do
  cwd node['localshop']['dir']
  environment({'HOME' => node['localshop']['dir']})
  command "/usr/local/bin/runinenv #{::File.join(node['localshop']['dir'],'shared','env')} localshop init"
  creates ::File.join(node['localshop']['dir'],'current','.localshop','localshop.db')
  action :nothing
  subscribes :run, "application[localshop]"
end