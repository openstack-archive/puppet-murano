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
# [*tenant*]
#  (Required) Tenant for cloudfoundry api
#
# [*bind_host*]
#  (Optional) Host on which murano cloudfoundry api should listen
#  Defaults to $::os_service_default.
#
# [*bind_port*]
#  (Optional) Port on which murano cloudfoundry api should listen
#  Defaults to $::os_service_default.
#
# [*auth_url*]
#  (Optional) Public identity endpoint
#  Defaults to 'http://127.0.0.1:5000'.
#
class murano::cfapi(
  $tenant,
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present',
  $bind_host      = $::os_service_default,
  $bind_port      = $::os_service_default,
  $auth_url       = 'http://127.0.0.1:5000',
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

  murano_cfapi_config {
    'cfapi/tenant':    value => $tenant;
    'cfapi/bind_host': value => $bind_host;
    'cfapi/bind_port': value => $bind_port;
    'cfapi/auth_url':  value => $auth_url;
  }

  package { 'murano-cfapi':
    ensure => $package_ensure,
    name   => $::murano::params::cfapi_package_name,
    tag    => ['openstack', 'murano-package'],
  }

  service { 'murano-cfapi':
    ensure => $service_ensure,
    name   => $::murano::params::cfapi_service_name,
    enable => $enabled,
    tag    => 'murano-service',
  }

}
