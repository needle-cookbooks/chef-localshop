#
# Author:: Cameron Johnston <cameron@needle.com>
# Cookbook Name:: localshop
# Recipe:: default
#
# Copyright:: 2013, Needle Inc. <cookbooks@needle.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

application 'localshop' do
  path node['localshop']['dir']
  owner node['localshop']['user']
  group node['localshop']['group']
  repository node['localshop']['repository']
  revision node['localshop']['revision']
  migrate true

  before_restart do
    directory node['localshop']['storage_dir'] do
      owner node['localshop']['user']
      group node['localshop']['group']
      mode 0750
    end
    link ::File.join(node['localshop']['dir'],'current','source') do
      to node['localshop']['storage_dir']
      owner node['localshop']['user']
      group node['localshop']['group']
    end
  end

  django do
    local_settings_file 'localshop.conf.py'
    settings_template 'localshop.conf.py.erb'
    migration_command "#{venv_python} manage.py syncdb --noinput && #{venv_python} manage.py migrate"
  end

  gunicorn do
    app_module :django
    virtualenv venv
    environment(localshop_env)
    host node['localshop']['address']
    port node['localshop']['port']
  end

  celery do
    config 'celery_settings.py'
    django true
    celeryd true
    broker do
      host 'localhost'
    end
    environment(localshop_env)
  end
end

