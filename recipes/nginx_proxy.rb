include_recipe "nginx"

template "#{node[:nginx][:dir]}/sites-available/localshop-proxy.conf" do
  source "nginx_proxy.conf.erb"
  mode '0640'
end