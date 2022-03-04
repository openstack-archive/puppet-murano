# == Class: murano::keystone::cfapi_auth
#
# Configures murano cfapi service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for murano cfapi user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'murano-cfapi'.
#
# [*auth_name*]
#   (Optional) Username for murano service.
#   Defaults to 'murano-cfapi'.
#
# [*email*]
#   (Optional) Email for murano user.
#   Defaults to 'murano@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for murano user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to aodh user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to aodh user.
#   Defaults to []
#
# [*configure_endpoint*]
#   (Optional) Should murano endpoint be configured?
#   Defaults to true.
#
# [*configure_user*]
#   (Optional) Should murano user be configured?
#   Defaults to false.
#
# [*configure_user_role*]
#   (Optional) Should murano user_role be configured?
#   Defaults to false.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'service-broker'.
#
# [*service_description*]
#   (Optional) Description of service.
#   Defaults to 'Murano Service Broker API'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8083
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8083
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8083
#
# === Examples
#
#  class { 'murano::keystone::cfapi_auth':
#    password     => 'secret',
#    public_url   => 'https://10.0.0.10:8083',
#    internal_url => 'https://10.0.0.11:8083',
#    admin_url    => 'https://10.0.0.11:8083',
#  }
#
class murano::keystone::cfapi_auth(
  $password,
  $service_name        = 'murano-cfapi',
  $auth_name           = 'murano-cfapi',
  $email               = 'murano@localhost',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $service_type        = 'service-broker',
  $service_description = 'Murano Service Broker API',
  $configure_endpoint  = true,
  $configure_user      = false,
  $configure_user_role = false,
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8083',
  $admin_url           = 'http://127.0.0.1:8083',
  $internal_url        = 'http://127.0.0.1:8083',
) {

  include murano::deps

  keystone::resource::service_identity { 'murano-cfapi':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
