# == Class: service_jenkins
#
# Run a Jenkins master on the node
#
class service_jenkins(
  $plugin_hash    = {},
  $config_hash    = {},
  $prefix         = '/jenkins',
  $https_redirect = false,
  $use_apache     = true,
  $root_redirect  = false,
) inherits ::service_jenkins::params {

  validate_hash($plugin_hash)
  validate_hash($config_hash)

  validate_string($prefix)
  validate_re($prefix, '^/', 'prefix must start with an slash')
  validate_re($prefix, '^\S+$', 'prefix may not contain whitespaces')

  validate_bool($https_redirect)
  validate_bool($root_redirect)
  validate_bool($use_apache)

  $config_hash_default = {
    'PREFIX'       => { value => $prefix },
    'JENKINS_ARGS' => { value => $::service_jenkins::params::jenkins_args },
  }

  $config_hash_real = merge($config_hash_default, $config_hash)

  class { '::jenkins':
    plugin_hash => $plugin_hash,
    config_hash => $config_hash_real,
  } ->
  Class['service_jenkins']

  include ::jenkins::master

  if $use_apache {

    if ! defined(Class['::service_webserver']) {
      include ::apache
      Class['::apache'] -> Class['service_jenkins']
    }

    include ::apache::mod::proxy
    include ::apache::mod::proxy_http

    if $https_redirect {
      # TODO: currently broken
      include ::apache::mod::rewrite
    }

    ::apache::custom_config { 'jenkins':
      content => template('service_jenkins/apache.conf.erb'),
    }

  }

}
