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
  $config_firewall = false,
) inherits ::service_jenkins::params {

  validate_hash($plugin_hash)
  validate_hash($config_hash)

  validate_string($prefix)
  validate_re($prefix, '^/', 'prefix must start with an slash')
  validate_re($prefix, '^\S+$', 'prefix may not contain whitespaces')

  validate_bool($https_redirect)
  validate_bool($root_redirect)
  validate_bool($use_apache)

  if defined('::service_baseline') {
    include ::service_baseline
  }
  elsif defined('::baseline') {
    include ::baseline
  }

  if $::proxy_http_host and $::proxy_http_port {
    $java_args = [
      "-Dhttp.proxyHost=${::proxy_http_host}",
      "-Dhttp.proxyPort=${::proxy_http_port}",
      "-Dhttps.proxyHost=${::proxy_http_host}",
      "-Dhttps.proxyPort=${::proxy_http_port}",
    ]
  }
  else {
    $java_args = []
  }

  $config_hash_default = {
    'PREFIX'       => { value => $prefix },
    'JENKINS_ARGS' => { value => $::service_jenkins::params::jenkins_args },
    'JAVA_ARGS'    => { value => join($java_args, ' ') },
  }

  $config_hash_real = merge($config_hash_default, $config_hash)

  class { '::jenkins':
    plugin_hash        => $plugin_hash,
    config_hash        => $config_hash_real,
    configure_firewall => $config_firewall,
  } ->
  Class['service_jenkins']

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
