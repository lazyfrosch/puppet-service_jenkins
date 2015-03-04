# TODO: remove when we can use a proper box
service { ['puppet', 'chef-client']:
  ensure => stopped,
  enable => false,
}

class { '::service_jenkins':
  root_redirect => true,
}
