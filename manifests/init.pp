# == Class: murano
#
#  murano base package & configuration
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*debug*]
#  (Optional) Should the service log debug messages
#  Defaults to undef
#
# [*use_syslog*]
#  (Optional) Should the service use Syslog
#  Defaults to undef
#
# [*use_stderr*]
#  (Optional) Should the service log to stderr
#  Defaults to undef
#
# [*log_facility*]
#  (Optional) Syslog facility to recieve logs
#  Defaults to undef
#
# [*log_dir*]
#  (Optional) Directory to store logs
#  Defaults to undef
#
# [*data_dir*]
#  (Optional) Directory to store data
#  Defaults to '/var/cache/murano'
#
# [*notification_driver*]
#  (Optional) Notification driver to use
#  Defaults to 'messagingv2'
#
# [*default_transport_url*]
#  (optional) A URL representing the messaging driver to use and its full
#  configuration. Transport URLs take the form:
#    transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#  (Optional) Should murano api use ha queues
#  Defaults to $::os_service_default
#
# [*rabbit_os_use_ssl*]
#   (Optional) Connect over SSL for openstack RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (Optional) How long to wait before reconnecting in response
#   to an AMQP consumer cancel notification. (floating point value)
#   Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*rabbit_own_host*]
#  (Optional) Host for murano rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_own_port*]
#  (Optional) Port for murano rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_own_user*]
#  (Optional) Username for murano rabbit server
#  Defaults to 'guest'
#
# [*rabbit_own_password*]
#  (Optional) Password for murano rabbit server
#  Defaults to 'guest'
#
# [*rabbit_own_vhost*]
#  (Optional) Virtual host for murano rabbit server
#  Defaults to 'murano'
#
# [*rabbit_own_use_ssl*]
#   (Optional) Connect over SSL for Murano RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*rabbit_own_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled)
#   for murano rabbit server.
#   Defaults to $::os_service_default
#
# [*service_host*]
#  (Optional) Host for murano to listen on
#  Defaults to '127.0.0.1'
#
# [*service_port*]
#  (Optional) Port for murano to listen on
#  Defaults to 8082
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*use_neutron*]
#  (Optional) Whether to use neutron
#  Defaults to false
#
# [*external_network*]
#  (Optional) Name of the external Neutron network which will be used
#  Defaults to $::murano::params::default_external_network
#
# [*default_router*]
#  (Optional) Router name for Murano networks
#  Defaults to $::os_service_default
#
# [*default_nameservers*]
#  (Optional) Domain Name Servers to use in Murano networks
#  Defaults to $::os_service_default
#
# [*use_trusts*]
#  (Optional) Whether to use trust token instead of user token
#  Defaults to $::os_service_default
#
# [*packages_service*]
#  (Optional) The service to store murano packages.
#  Defaults to $::os_service_default.
#
# == database configuration options
#
# [*database_connection*]
#   (Optional) Database URI for murano
#   Defaults to undef.
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to undef.
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to undef.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to undef.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to undef.
#
# [*sync_db*]
#   (Optional) Enable dbsync
#   Defaults to true.
#
# == keystone authentication options
#
# [*admin_user*]
#  (Optional) Username for murano credentials
#  Defaults to 'murano'
#
# [*admin_password*]
#  (Required) Password for murano credentials
#
# [*admin_tenant_name*]
#  (Optional) Tenant for admin_username
#  Defaults to 'services'
#
# [*auth_uri*]
#  (Optional) Public identity endpoint
#  Defaults to 'http://127.0.0.1:5000'
#
# [*memcached_servers*]
#   (optinal) a list of memcached server(s) to use for caching. If left
#   undefined, tokens will instead be cached in-process.
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the murano config.
#   Defaults to false.
#
# === Deprecated Parameters
#
# [*identity_uri*]
#  (Optional) Admin identity endpoint
#  Defaults to 'http://127.0.0.1:35357/'
#
# [*rabbit_os_host*]
#  (Optional) Host for openstack rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_os_hosts*]
#  (Optional) Hosts for openstack rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_os_port*]
#  (Optional) Port for openstack rabbit server
#  Defaults to $::os_service_default
#
# [*rabbit_os_user*]
#  (Optional) Username for openstack rabbit server
#  Defaults to 'guest'
#
# [*rabbit_os_password*]
#  (Optional) Password for openstack rabbit server
#  Defaults to 'guest'
#
# [*rabbit_os_virtual_host*]
#   (optional) The RabbitMQ virtual host.
#   Defaults to $::os_service_default
#
# [*signing_dir*]
#   (Optional) Directory used to cache files related to PKI tokens.
#   Defaults to undef
#
class murano(
  $admin_password,
  $package_ensure          = 'present',
  $debug                   = undef,
  $use_syslog              = undef,
  $use_stderr              = undef,
  $log_facility            = undef,
  $log_dir                 = undef,
  $data_dir                = '/var/cache/murano',
  $notification_driver     = 'messagingv2',
  $default_transport_url   = $::os_service_default,
  $rpc_response_timeout    = $::os_service_default,
  $control_exchange        = $::os_service_default,
  $rabbit_os_use_ssl       = $::os_service_default,
  $kombu_ssl_ca_certs      = $::os_service_default,
  $kombu_ssl_certfile      = $::os_service_default,
  $kombu_ssl_keyfile       = $::os_service_default,
  $kombu_ssl_version       = $::os_service_default,
  $kombu_reconnect_delay   = $::os_service_default,
  $kombu_failover_strategy = $::os_service_default,
  $kombu_compression       = $::os_service_default,
  $rabbit_ha_queues        = $::os_service_default,
  $rabbit_own_host         = $::os_service_default,
  $rabbit_own_port         = $::os_service_default,
  $rabbit_own_user         = 'guest',
  $rabbit_own_password     = 'guest',
  $rabbit_own_vhost        = 'murano',
  $rabbit_own_use_ssl      = $::os_service_default,
  $rabbit_own_ca_certs     = $::os_service_default,
  $service_host            = '127.0.0.1',
  $service_port            = '8082',
  $use_ssl                 = false,
  $cert_file               = $::os_service_default,
  $key_file                = $::os_service_default,
  $ca_file                 = $::os_service_default,
  $use_neutron             = false,
  $external_network        = $::murano::params::default_external_network,
  $default_router          = $::os_service_default,
  $default_nameservers     = $::os_service_default,
  $use_trusts              = $::os_service_default,
  $packages_service        = $::os_service_default,
  $database_connection     = undef,
  $database_idle_timeout   = undef,
  $database_min_pool_size  = undef,
  $database_max_pool_size  = undef,
  $database_max_retries    = undef,
  $database_retry_interval = undef,
  $database_max_overflow   = undef,
  $sync_db                 = true,
  $admin_user              = 'murano',
  $admin_tenant_name       = 'services',
  $auth_uri                = 'http://127.0.0.1:5000',
  $memcached_servers       = $::os_service_default,
  $purge_config            = false,
  # Deprecated
  $identity_uri            = 'http://127.0.0.1:35357/',
  $rabbit_os_host          = $::os_service_default,
  $rabbit_os_port          = $::os_service_default,
  $rabbit_os_hosts         = $::os_service_default,
  $rabbit_os_virtual_host  = $::os_service_default,
  $rabbit_os_user          = 'guest',
  $rabbit_os_password      = 'guest',
  $signing_dir             = undef,
) inherits murano::params {

  include ::murano::deps
  include ::murano::logging
  include ::murano::policy
  include ::murano::db

  validate_string($admin_password)

  if !is_service_default($rabbit_os_host) or
    !is_service_default($rabbit_os_hosts) or
    !is_service_default($rabbit_os_password) or
    !is_service_default($rabbit_os_port) or
    !is_service_default($rabbit_os_user) or
    !is_service_default($rabbit_os_virtual_host) {
    warning("murano::rabbit_os_host, murano::rabbit_os_hosts, murano::rabbit_os_password, \
murano::rabbit_os_port, murano::rabbit_os_userid and murano::rabbit_os_virtual_host are \
deprecated. Please use murano::default_transport_url instead.")
  }

  if $signing_dir {
    warning('signing_dir parameter is deprecated, has no effect and will be removed in the P release.')
  }

  package { 'murano-common':
    ensure => $package_ensure,
    name   => $::murano::params::common_package_name,
    tag    => ['openstack', 'murano-package'],
  }

  $service_protocol = $use_ssl ? {
    true    => 'https',
    default => 'http',
  }

  resources { 'murano_config':
    purge => $purge_config,
  }

  murano_config {
    'networking/router_name':   value => $default_router;
    'networking/create_router': value => $use_neutron;
  }

  if $use_neutron {
    if is_service_default($default_router) {
      fail('The default_router parameter is required when use_neutron is set to true')
    }
    murano_config {
      'networking/external_network': value => $external_network;
      'networking/driver': value => 'neutron';
    }
  } else {
    murano_config {
      'networking/external_network': ensure => 'absent';
      'networking/driver': value => 'nova';
    }
  }

  if $use_ssl {
    if is_service_default($cert_file) {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if is_service_default($key_file) {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
    murano_config {
      'ssl/cert_file' : value => $cert_file;
      'ssl/key_file' :  value => $key_file;
      'ssl/ca_file' :   value => $ca_file;
    }
  }

  murano_config {
    'murano/url' :                           value => "${service_protocol}://${service_host}:${service_port}";

    'engine/use_trusts' :                    value => $use_trusts;

    'rabbitmq/login' :                       value => $rabbit_own_user;
    'rabbitmq/password' :                    value => $rabbit_own_password;
    'rabbitmq/host' :                        value => $rabbit_own_host;
    'rabbitmq/port' :                        value => $rabbit_own_port;
    'rabbitmq/virtual_host' :                value => $rabbit_own_vhost;
    'rabbitmq/ssl' :                         value => $rabbit_own_use_ssl;
    'rabbitmq/ca_certs' :                    value => $rabbit_own_ca_certs;

    'keystone_authtoken/auth_uri' :          value => $auth_uri;
    'keystone_authtoken/admin_user' :        value => $admin_user;
    'keystone_authtoken/admin_tenant_name' : value => $admin_tenant_name;
    'keystone_authtoken/admin_password' :    value => $admin_password;
    'keystone_authtoken/identity_uri' :      value => $identity_uri;
    'keystone_authtoken/memcached_servers':  value => join(any2array($memcached_servers), ',');

    'networking/default_dns':                value => $default_nameservers;

    'engine/packages_service':               value => $packages_service,
  }

  oslo::messaging::rabbit { 'murano_config':
    kombu_ssl_version       => $kombu_ssl_version,
    kombu_ssl_keyfile       => $kombu_ssl_keyfile,
    kombu_ssl_certfile      => $kombu_ssl_certfile,
    kombu_ssl_ca_certs      => $kombu_ssl_ca_certs,
    kombu_reconnect_delay   => $kombu_reconnect_delay,
    kombu_failover_strategy => $kombu_failover_strategy,
    kombu_compression       => $kombu_compression,
    rabbit_host             => $rabbit_os_host,
    rabbit_port             => $rabbit_os_port,
    rabbit_hosts            => $rabbit_os_hosts,
    rabbit_use_ssl          => $rabbit_os_use_ssl,
    rabbit_userid           => $rabbit_os_user,
    rabbit_password         => $rabbit_os_password,
    rabbit_ha_queues        => $rabbit_ha_queues,
    rabbit_virtual_host     => $rabbit_os_virtual_host,
  }

  oslo::messaging::default { 'murano_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'murano_config':
    driver => $notification_driver,
  }

  if $sync_db {
    include ::murano::db::sync
  }
}
