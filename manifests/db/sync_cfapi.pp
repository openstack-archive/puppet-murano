#
# Class to execute murano_cfapi dbsync
#
class murano::db::sync_cfapi {

  include ::murano::params

  Package <| title == 'murano-common' |> ~> Exec['murano-cfapi-dbmanage']
  Exec['murano-cfapi-dbmanage'] ~> Service <| tag == 'murano-service' |>

  Murano_cfapi_config <| title == 'database/connection' |> ~> Exec['murano-cfapi-dbmanage']

  exec { 'murano-cfapi-dbmanage':
    command     => $::murano::params::cfapi_dbmanage_command,
    path        => '/usr/bin',
    user        => 'murano_cfapi',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
  }

}
