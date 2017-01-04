# Matchers for chefspec 3

if defined?(ChefSpec)
  def create_nfs_export(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nfs_export, :create, resource_name)
  end
  def delete_nfs_export(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:nfs_export, :delete, resource_name)
  end
end
