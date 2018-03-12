#
# Class to execute murano dbsync
#
class murano::db::sync {

  include ::murano::deps
  include ::murano::params

  exec { 'murano-dbmanage':
    command     => $::murano::params::dbmanage_command,
    path        => '/usr/bin',
    user        => 'murano',
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
