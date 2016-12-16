# == Class: murano::db::postgresql_cfapi
#
# The murano::db::postgresql_cfapi creates a PostgreSQL database for murano_cfapi.
# It must be used on the PostgreSQL server.
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
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class murano::db::postgresql_cfapi(
  $password,
  $dbname     = 'murano_cfapi',
  $user       = 'murano_cfapi',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::murano::deps

  validate_string($password)

  ::openstacklib::db::postgresql { 'murano_cfapi':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['murano::db::begin']
  ~> Class['murano::db::postgresql_cfapi']
  ~> Anchor['murano::db::end']

}
