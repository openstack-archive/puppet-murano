# == Class: murano::db::mysql_cfapi
#
# The murano::db::mysql_cfapi class creates a MySQL database for murano_cfapi.
# It must be used on the MySQL server.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'murano_cfapi'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'murano_cfapi'.
#
# [*host*]
#   (Optional) The default source host user is allowed to connect from.
#   Defaults to '127.0.0.1'
#
# [*allowed_hosts*]
#   (Optional) Other hosts the user is allowed to connect from.
#   Defaults to 'undef'.
#
# [*charset*]
#   (Optional) The database charset.
#   Defaults to 'utf8'.
#
# [*collate*]
#   (Optional) Charset collate of murano_cfapi database.
#    Defaults to 'utf8_general_ci'.
#
class murano::db::mysql_cfapi(
  $password,
  $dbname        = 'murano_cfapi',
  $user          = 'murano_cfapi',
  $host          = '127.0.0.1',
  $allowed_hosts = undef,
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
) {

  include ::murano::deps

  validate_string($password)

  ::openstacklib::db::mysql{ 'murano_cfapi':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['murano::db::begin']
  ~> Class['murano::db::mysql_cfapi']
  ~> Anchor['murano::db::end']

}
