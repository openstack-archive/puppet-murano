# == Class: murano::engine
#
#  murano engine package & service
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
# [*workers*]
#  (Optional) Number of workers for Murano Engine
#  Defaults to $::os_workers
#
class murano::engine(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
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
    'engine/engine_workers': value => $workers;
  }

  package { 'murano-engine':
    ensure => $package_ensure,
    name   => $::murano::params::engine_package_name,
    tag    => ['openstack', 'murano-package'],
  }

  service { 'murano-engine':
    ensure => $service_ensure,
    name   => $::murano::params::engine_service_name,
    enable => $enabled,
    tag    => 'murano-service',
  }

}
