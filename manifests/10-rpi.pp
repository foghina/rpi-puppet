$user = 'felix'

# Users
# =====

user {$user:
  ensure      => present,
  managehome  => true,
  groups      => ['wheel']
}

# Packages
# ========

package {'bash-completion':
  ensure => present
}

package {'sudo':
  ensure => present
}

package {'ntp':
  ensure => present
}

package {'vim':
  ensure => present
}

package {'git':
  ensure => present
}

# Config files
# ============

file {"/etc/hostname":
  owner   => root,
  group   => root,
  mode    => 0644,
  source  => "puppet:///modules/hostname/hostname"
}

file {"/etc/sudoers":
  owner    => root,
  group    => root,
  mode     => 440,
  source   => "puppet:///modules/sudo/sudoers",
  require  => Package["sudo"]
}

# Services
# ========

service {'ntpd':
  ensure   => running,
  enable   => true,
  require  => Package["ntp"]
}

# Misc
# ====

class {"timezone":
  timezone => "UTC"
}

host {"pi":
  ensure   => present,
  ip       => '127.0.0.1',
  require  => File["/etc/hostname"]
}

