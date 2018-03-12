#
# Class to execute murano_cfapi dbsync
#
class murano::db::sync_cfapi {

  include ::murano::deps
  include ::murano::params

  exec { 'murano-cfapi-dbmanage':
    command     => $::murano::params::cfapi_dbmanage_command,
    path        => '/usr/bin',
    user        => 'murano_cfapi',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['murano::install::end'],
      Anchor['murano::config::end'],
      Anchor['murano::dbsync::begin']
    ],
    notify      => Anchor['murano::dbsync::end'],
    tag         => 'openstack-db',
  }

}
