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

%w{ config packages }.each do |dirname|
  directory ::File.join(node['localshop']['dir'],'shared',dirname) do
    owner node['localshop']['user']
    group node['localshop']['group']
    mode 00750
    recursive true
    action :create
  end
end

template ::File.join(node['localshop']['dir'],'shared','config','localshop.conf.py') do
  source 'localshop.conf.py.erb'
  owner node['localshop']['user']
  group node['localshop']['group']
  mode 0640
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
    'config' => '.localshop'
    })
  environment({'HOME' => ::File.join(node['localshop']['dir'],'current')})
  
  django do
  end
  
  gunicorn do
    app_module :django
    environment({'HOME' => ::File.join(node['localshop']['dir'],'current')})
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