def deploy_application(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(:application, :deploy, resource_name)
end
