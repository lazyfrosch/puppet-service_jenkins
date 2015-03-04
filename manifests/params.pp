# == Class: service_jenkins::params
#
# Default parameters
#
class service_jenkins::params {

  if $::osfamily == 'Debian' {

    $jenkins_args = '--webroot=/var/cache/jenkins/war --httpPort=$HTTP_PORT --ajp13Port=$AJP_PORT --prefix=$PREFIX'

  }
  else {
    fail("Sorry, your osfamily ${::osfamily} is not supported yet.")
  }

}
