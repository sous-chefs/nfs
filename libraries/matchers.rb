# Matchers for chefspec 3

if defined?(ChefSpec)
  def create_export(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:export, :create, resource_name)
  end
end
