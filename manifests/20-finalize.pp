$user = 'felix'

exec {'passwd -l root':
  path    => '/usr/bin',
  onlyif  => "test `passwd -S ${user} | grep L | wc -l` -eq 0"
}
