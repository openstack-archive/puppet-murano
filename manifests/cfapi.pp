# == Class: murano::cfapi
#
#  murano service broker package & service
#
# === Parameters
#
# [*manage_service*]
#  (Optional) Whether the service should be managed by Puppet
#  Defaults to true
#
# [*enabled*]
#  (Optional) Should the service be enabled
#  Defaults to true
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*host*]
#  (Optional) Host on which murano cloudfoundry api should listen
#  Defaults to $::os_service_default.
#
# [*port*]
#  (Optional) Port on which murano cloudfoundry api should listen
#  Defaults to $::os_service_default.
#
class murano::cfapi(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $host           = $::os_service_default,
  $port           = $::os_service_default,
) {

  include ::murano::params
  include ::murano::policy

  Murano_config<||> ~> Service['murano-cfapi']
  Class['murano::policy'] -> Service['murano-cfapi']

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  murano_config {
    'DEFAULT/cfapi_bind_host': value => $host;
    'DEFAULT/cfapi_bind_port': value => $port;
  }

  package { 'murano-cfapi':
    ensure => $package_ensure,
    name   => $::murano::params::cfapi_package_name,
  }

  service { 'murano-cfapi':
    ensure  => $service_ensure,
    name    => $::murano::params::cfapi_service_name,
    enable  => $enabled,
    require => Package['murano-cfapi'],
  }

  Package['murano-cfapi'] ~> Service['murano-cfapi']
  Murano_paste_ini_config<||> ~> Service['murano-cfapi']
}
