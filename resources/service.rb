resource_name :yandex_disk_service
provides :yandex_disk_service

attribute :name, String, default: 'yandex-disk'
attribute :executable, String, default: '/usr/bin/yandex-disk'
attribute :configuration_path, default: '/etc/yandex-disk/config.cfg'

action_class do
  # Prepend service name with `yandex-disk-` if it's not done already
  def name
    name = new_resource.name
    name = 'yandex-disk' if new_resource.name == 'default'
    chunks = name.split('-')
    if chunks[0] == 'yandex'
      chunks.shift
    end
    if chunks[0] == 'disk'
      chunks.shift
    end
    chunks.unshift('yandex', 'disk').join('-')
  end

  def unit
    systemd_service name do
      unit_description 'Yandex.Disk daemon service'
      command = [
          new_resource.executable,
          'start',
          '--config',
          new_resource.configuration_path
      ]
      service_exec_start command.map {|entry| Shellwords.escape(entry) }.join(' ')
      service_type 'forking'
      install_wanted_by 'multi-user.target'
    end
  end
end

%i[create delete start stop restart].each do |action|
  action action do
    unit.action = action
  end
end
