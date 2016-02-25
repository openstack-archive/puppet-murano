# == Class: murano::keystone::cfapi_auth
#
# Configures murano cfapi service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for murano cfapi user.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of auth_name.
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
# [*configure_endpoint*]
#   (Optional) Should murano endpoint be configured?
#   Defaults to 'true'.
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
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8083
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8083
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8083
#   This url should *not* contain any trailing '/'.
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
  $service_name        = undef,
  $auth_name           = 'murano-cfapi',
  $email               = 'murano@localhost',
  $tenant              = 'services',
  $service_type        = 'service-broker',
  $service_description = 'Murano Service Broker API',
  $configure_endpoint  = true,
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:8083',
  $admin_url           = 'http://127.0.0.1:8083',
  $internal_url        = 'http://127.0.0.1:8083',
) {

  $real_service_name = pick($service_name, $auth_name)

  keystone::resource::service_identity { $real_service_name:
    configure_user      => false,
    configure_user_role => false,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }
}
