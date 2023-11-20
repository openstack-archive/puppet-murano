# == Class: murano::client
#
#  murano client package
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
class murano::client(
  $package_ensure = 'present',
) {

  include murano::deps
  include murano::params

  # NOTE(tkajinam): murano-package tag is used because muranoclient is required
  #                 by murano
  package { 'python-muranoclient':
    ensure => $package_ensure,
    name   => $::murano::params::pythonclient_package_name,
    tag    => ['openstack', 'openstackclient', 'murano-package'],
  }

}
