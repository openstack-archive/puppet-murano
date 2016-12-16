# == Class: murano:db_cfapi
#
# Configure the Murano CFAPI database
#
# == Parameters
#
# [*database_connection*]
#   (optional) Connection url to connect to CFAPI Murano database.
#   Defaults to $::os_service_default
#
# [*database_max_retries*]
#   (Optional) Maximum number of database connection retries during startup.
#   Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default.
#
# [*database_idle_timeout*]
#   (Optional) Timeout before idle SQL connections are reaped.
#   Defaults to $::os_service_default.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   Defaults to $::os_service_default.
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to $::os_service_default.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to $::os_service_default.
#
# [*database_db_max_retries*]
#   (Optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
class murano::db_cfapi (
  $database_connection       = $::os_service_default,
  $database_idle_timeout     = $::os_service_default,
  $database_min_pool_size    = $::os_service_default,
  $database_max_pool_size    = $::os_service_default,
  $database_max_retries      = $::os_service_default,
  $database_retry_interval   = $::os_service_default,
  $database_max_overflow     = $::os_service_default,
  $database_db_max_retries   = $::os_service_default,
) {

  include ::murano::deps

  if !is_service_default($database_connection) {

    validate_re($database_connection, '^(mysql(\+pymysql)?|postgresql):\/\/(\S+:\S+@\S+\/\S+)?')

    oslo::db { 'murano_cfapi_config':
      connection     => $database_connection,
      idle_timeout   => $database_idle_timeout,
      min_pool_size  => $database_min_pool_size,
      max_pool_size  => $database_max_pool_size,
      max_retries    => $database_max_retries,
      retry_interval => $database_retry_interval,
      max_overflow   => $database_max_overflow,
      db_max_retries => $database_db_max_retries,
    }
  }

}
