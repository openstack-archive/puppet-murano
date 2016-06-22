# == Class: murano::api
#
#  murano api package & service
#
# === Parameters
#
# [*manage_service*]
#  (Optional) Should the service be enabled
#  Defaults to true
#
# [*enabled*]
#  (Optional) Whether the service should be managed by Puppet
#  Defaults to true
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*host*]
#  (Optional) Host on which murano api should listen
#  Defaults to $::os_service_default.
#
# [*port*]
#  (Optional) Port on which murano api should listen
#  Defaults to $::os_service_default.
#
class murano::api(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $host           = $::os_service_default,
  $port           = $::os_service_default,
) {

  include ::murano::params
  include ::murano::policy

  Murano_config<||> ~> Service['murano-api']
  Class['murano::policy'] -> Service['murano-api']

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  murano_config {
    'DEFAULT/bind_host': value => $host;
    'DEFAULT/bind_port': value => $port;
  }

  package { 'murano-api':
    ensure => $package_ensure,
    name   => $::murano::params::api_package_name,
    tag    => ['openstack', 'murano-package'],
  }

  service { 'murano-api':
    ensure  => $service_ensure,
    name    => $::murano::params::api_service_name,
    enable  => $enabled,
    require => Package['murano-api'],
    tag     => 'murano-service',
  }

  Package['murano-api'] ~> Service['murano-api']
  Murano_paste_ini_config<||> ~> Service['murano-api']

}
