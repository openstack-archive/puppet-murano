# == Class: murano::params
#
# Parameters for puppet-murano
#
class murano::params {
  $dbmanage_command         = 'murano-db-manage --config-file /etc/murano/murano.conf upgrade'
  $default_external_network = 'public'
  # service names
  $api_service_name         = 'murano-api'
  $engine_service_name      = 'murano-engine'

  case $::osfamily {
    'RedHat': {
      # package names
      $api_package_name          = 'openstack-murano-api'
      $cfapi_package_name        = 'openstack-murano-cf-api'
      $common_package_name       = 'openstack-murano-common'
      $engine_package_name       = 'openstack-murano-engine'
      $pythonclient_package_name = 'python-muranoclient'
      $dashboard_package_name    = 'openstack-murano-dashboard'
      # service names
      $cfapi_service_name        = 'murano-cf-api'
      # dashboard config file
      $local_settings_path       = '/etc/openstack-dashboard/local_settings'
      $pymysql_package_name      = undef
    }
    'Debian': {
      # package names
      $api_package_name          = 'murano-api'
      $cfapi_package_name        = 'murano-cfapi'
      $common_package_name       = 'murano-common'
      $engine_package_name       = 'murano-engine'
      $pythonclient_package_name = 'python-muranoclient'
      $dashboard_package_name    = 'python-murano-dashboard'
      # service names
      $cfapi_service_name        = 'murano-cfapi'
      # dashboard config file
      $local_settings_path       = '/etc/openstack-dashboard/local_settings.py'
      $pymysql_package_name      = 'python-pymysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}")
    }
  }
}
