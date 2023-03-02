# == Class: murano:db_cfapi
#
# Configure the Murano CFAPI database
#
# == Parameters
#
# [*database_connection*]
#   (optional) Connection url to connect to CFAPI Murano database.
#   Defaults to $facts['os_service_default']
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to $facts['os_service_default'].
#
# [*database_connection_recycle_time*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to $facts['os_service_default'].
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to $facts['os_service_default'].
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $facts['os_service_default'].
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $facts['os_service_default'].
#
# [*database_db_max_retries*]
#   (Optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $facts['os_service_default']
#
# DEPRECATED PARAMETERS
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to undef
#
class murano::db_cfapi (
  $database_connection              = $facts['os_service_default'],
  $database_connection_recycle_time = $facts['os_service_default'],
  $database_max_pool_size           = $facts['os_service_default'],
  $database_max_retries             = $facts['os_service_default'],
  $database_retry_interval          = $facts['os_service_default'],
  $database_max_overflow            = $facts['os_service_default'],
  $database_db_max_retries          = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $database_idle_timeout            = undef,
) {

  include murano::deps

  if $database_idle_timeout != undef {
    warning('The database_idle_timeout parameter is deprecated and has no effect.')
  }

  if !is_service_default($database_connection) {
    oslo::db { 'murano_cfapi_config':
      connection              => $database_connection,
      connection_recycle_time => $database_connection_recycle_time,
      max_pool_size           => $database_max_pool_size,
      max_retries             => $database_max_retries,
      retry_interval          => $database_retry_interval,
      max_overflow            => $database_max_overflow,
      db_max_retries          => $database_db_max_retries,
    }
  }

}
