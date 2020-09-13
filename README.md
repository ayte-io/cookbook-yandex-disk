# ayte-yandex-disk

Cookbook for managing Yandex.Disk Linux daemon.

Currently supports Ubuntu 16.04+ only.

## Recipes

### install

`ayte-yandex-disk::install` recipe will install the CLI tool itself
using [official Yandex repo](https://yandex.com/support/disk/cli-clients.html).

## Resources

### yandex_disk_auth

Creates authentication (passwd) file at specified location:

```ruby
yandex_disk_auth '/etc/yandex/disk/auth' do
  username 'cat'
  password 'box' # sensitive, implied that it will be seeded from data bag
  force false # whether to force run if file already exists, optional
  owner 'user' # optional
  group 'user' # optional
end
```

### yandex_disk_configuration

```ruby
yandex_disk_configuration '/etc/yandex/disk/configuration' do
  storage_path '/var/yandex/disk' # required, no auto-detection magic
  auth_file_path '/etc/yandex/disk/auth' # required
  proxy 'no' # optional
  exclusions %w[Music] # optional
  extra(
    startonstartofindicator: 'yes',
    stoponexitfromindicator: 'no'
  ) # optional
  owner 'user' # optional
  group 'user' # optional
end
```

### yandex_disk_service

Adds systemd service for automatic startup.

```ruby
yandex_disk_service 'yandex-disk' do
  configuration_path '/etc/yandex/disk/configuration'
end
```

This cookbook is likely to receive no further updates due to yandex 
public image.

## Licensing

[MIT](LICENSE-MIT) / [UPL-1.0](LICENSE-UPL-1.0)
