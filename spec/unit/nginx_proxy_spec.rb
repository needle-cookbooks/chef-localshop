require 'spec_helper'

describe 'localshop::nginx_proxy' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  before { stub_command('which nginx').and_return(nil) }

  it 'sets up nginx proxy' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/localshop-proxy.conf').with(
      source: 'nginx_proxy.conf.erb',
      mode: '0640'
    )
  end
end
