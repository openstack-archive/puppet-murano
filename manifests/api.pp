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
# [*workers*]
#  (Optional) Number of workers for Murano Api
#  Defaults to $::os_workers
#
class murano::api(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $host           = $::os_service_default,
  $port           = $::os_service_default,
  $workers        = $::os_workers,
) {

  include ::murano::deps
  include ::murano::params
  include ::murano::policy

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
    'murano/api_workers': value => $workers;
  }

  package { 'murano-api':
    ensure => $package_ensure,
    name   => $::murano::params::api_package_name,
    tag    => ['openstack', 'murano-package'],
  }

  service { 'murano-api':
    ensure => $service_ensure,
    name   => $::murano::params::api_service_name,
    enable => $enabled,
    tag    => 'murano-service',
  }

}
