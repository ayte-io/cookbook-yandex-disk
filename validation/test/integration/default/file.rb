describe file('/tmp/yandex-disk/storage/munchy.txt') do
  its('content') { should match %r{chomp chomp} }
end
