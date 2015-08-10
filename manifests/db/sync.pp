#
# Class to execute murano dbsync
#
class murano::db::sync {

  include ::murano::params

  Package <| title == 'murano-common' |> ~> Exec['murano-dbmanage']
  Exec['murano-dbmanage'] ~> Service <| tag == 'murano-service' |>

  Murano_config <| title == 'database/connection' |> ~> Exec['murano-dbmanage']

  exec { 'murano-dbmanage':
    command     => $::murano::params::dbmanage_command,
    path        => '/usr/bin',
    user        => 'murano',
    refreshonly => true,
    logoutput   => on_failure,
  }

}
