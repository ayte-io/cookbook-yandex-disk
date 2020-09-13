resource_name :yandex_disk_auth
provides :yandex_disk_auth

attribute :path, name_attribute: true
attribute :username, [String, Symbol], required: true, sensitive: true
attribute :password, [String, Symbol], required: true, sensitive: true
attribute :force, [TrueClass, FalseClass], default: false
attribute :executable, String, default: '/usr/bin/yandex-disk'
attribute :owner, String
attribute :group, String

action :create do
  if ::File.exist?(new_resource.path) && !new_resource.force
    next
  end
  directory ::File.dirname(new_resource.path) do
    recursive true
    owner new_resource.owner if new_resource.owner
    group new_resource.group if new_resource.group
  end

  command = Mixlib::ShellOut.new(
      new_resource.executable,
      'token',
      new_resource.username,
      new_resource.path,
      input: new_resource.password
  )
  command.run_command
  command.error!
end
