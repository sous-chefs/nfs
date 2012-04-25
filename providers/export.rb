def load_current_resource
  @export = Chef::Resource::NfsExport.new(new_resource.directory)
  Chef::Log.debug("Checking whether #{new_resource.directory} is already an NFS export")
  @export.exists node['nfs']['exports'].detect {|x| x.match "^#{new_resource.directory}" }
end

action :create do
  unless @export.exists
    ro_rw = new_resource.writeable ? "rw" : "ro"
    sync_async = new_resource.sync ? "sync" : "async"
    extra_options = new_resource.extra_options.join(',')
    extra_options = ",#{extra_options}" unless extra_options == ""
    export = "#{new_resource.directory} #{new_resource.network}(#{ro_rw},#{sync_async}#{extra_options})"
    node['nfs']['exports'] << export
    execute "notify_export_create" do
      command "/bin/true"
      notifies :create, resources("template[/etc/exports]")
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end
