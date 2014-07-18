file {'/etc/pacman.d/mirrorlist.backup':
  ensure   => file,
  replace  => false,
  source   => '/etc/pacman.d/mirrorlist'
}
exec {'uncomment-servers':
  path     => '/usr/bin',
  command  => 'sed -i \'s/^# Server/Server/\' /etc/pacman.d/mirrorlist.backup',
  require  => File['/etc/pacman.d/mirrorlist.backup']
}
exec {'rankmirrors':
  path       => '/usr/bin',
  command    => 'rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist',
  timeout    => 0,
  logoutput  => true,
  require    => Exec['uncomment-servers']
}
exec {'update':
  path       => '/usr/bin',
  command    => 'pacman -Syyu --noconfirm',
  timeout    => 0,
  logoutput  => true,
  require    => Exec['rankmirrors']
}
notify {'reboot':
  message  => 'Package setup and update complete, please reboot and run next puppet script.',
  require  => Exec['update']
}
