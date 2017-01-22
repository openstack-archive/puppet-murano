# == Class: murano::deps
#
#  Murano anchors and dependency management
#
class murano::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'murano::install::begin': }
  -> Package<| tag == 'murano-package'|>
  ~> anchor { 'murano::install::end': }
  -> anchor { 'murano::config::begin': }
  -> Murano_config<||>
  ~> anchor { 'murano::config::end': }
  -> anchor { 'murano::db::begin': }
  -> anchor { 'murano::db::end': }
  ~> anchor { 'murano::dbsync::begin': }
  -> anchor { 'murano::dbsync::end': }
  ~> anchor { 'murano::service::begin': }
  ~> Service<| tag == 'murano-service' |>
  ~> anchor { 'murano::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['murano::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['murano::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['murano::config::end']

  # Installation or config changes will always restart services.
  Anchor['murano::install::end'] ~> Anchor['murano::service::begin']
  Anchor['murano::config::end']  ~> Anchor['murano::service::begin']
}
