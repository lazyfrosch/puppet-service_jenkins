# == Class: service_jenkins
#
# EXPLAIN ME
#
class service_jenkins(
) inherits ::service_jenkins::params {

  class { '::jenkins':
  } ->
  Class['service_jenkins']

}
