# == Class: murano::keystone::auth
#
# Configures murano service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for murano user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'murano'.
#
# [*auth_name*]
#   (Optional) Username for murano service.
#   Defaults to 'murano'.
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
#   Defaults to true.
#
# [*configure_user_role*]
#   (Optional) Should murano user role be configured?
#   Defaults to 'true'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'application-catalog'.
#
# [*service_description*]
#   (Optional) Description of service.
#   Defaults to 'Murano Application Catalog'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8082
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8082
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8082
#
# === Examples
#
#  class { 'murano::keystone::auth':
#    password     => 'secret',
#    public_url   => 'https://10.0.0.10:8082',
#    internal_url => 'https://10.0.0.11:8082',
#    admin_url    => 'https://10.0.0.11:8082',
#  }
#
class murano::keystone::auth(
  $password,
  $service_name        = 'murano',
  $auth_name           = 'murano',
  $email               = 'murano@localhost',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $service_type        = 'application-catalog',
  $service_description = 'Murano Application Catalog',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8082',
  $admin_url           = 'http://127.0.0.1:8082',
  $internal_url        = 'http://127.0.0.1:8082',
) {

  include murano::deps

  keystone::resource::service_identity { 'murano':
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
