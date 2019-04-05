apt_repository 'yandex-disk-daemon' do
  uri 'http://repo.yandex.ru/yandex-disk/deb/'
  key 'http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG'
  distribution 'stable'
  components ['main']
end

package 'yandex-disk'
