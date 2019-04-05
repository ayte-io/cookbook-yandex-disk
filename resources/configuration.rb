require 'mixlib/shellout'

resource_name :yandex_disk_configuration

attribute :path, [String, Symbol], name_attribute: true, required: true
attribute :storage_path, [String, Symbol], required: true
attribute :auth_file_path, [String, Symbol], required: true
attribute :proxy, [String, Symbol], default: :no
attribute :exclusions, Array
attribute :extra, Hash, default: {}
attribute :owner, String
attribute :group, String

action_class do
  def auth_file
    ::File.join(new_resource.path, 'passwd')
  end
end

action :create do
  directory ::File.dirname(new_resource.path) do
    recursive true
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
  end
  values = {}
  values.update(new_resource.extra)
  values[:proxy] = new_resource.proxy
  values[:dir] = new_resource.storage_path
  values[:auth] = new_resource.auth_file_path
  values[:'exclude-dirs'] = new_resource.exclusions.join(',') if new_resource.exclusions
  template new_resource.path do
    source 'configuration.erb'
    variables values: values
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
    cookbook 'ayte-yandex-disk'
  end
end

action :remove do
  file new_resource.path do
    action :delete
  end
end
