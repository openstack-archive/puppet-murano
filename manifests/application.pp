# == Resource: murano::application
#
#  murano application importer
#
# === Parameters
#
# [*package_ensure*]
#  (Optional) Ensure state for package
#  Defaults to 'present'
#
# [*package_name*]
#  (Optional) Application package name
#  Defaults to $title
#
# [*package_category*]
#  (Optional) Application category
#  Defaults to 'undef'
#
# [*exists_action*]
#  (Optional) Default action when a package
#  already exists: s - skip, a - abort,
#  u - update.
#  Defaults to 's'
#
# [*public*]
#  (Optional) Make the package available for users
#  from other tenants
#  Defaults to true
#
define murano::application (
  $package_ensure   = 'present',
  $package_name     = $title,
  $package_category = undef,
  $exists_action    = 's',
  $public           = true,
) {

  include ::murano::deps

  $package_path="/var/cache/murano/meta/${package_name}.zip"

  murano_application { $package_name:
    ensure        => $package_ensure,
    package_path  => $package_path,
    exists_action => $exists_action,
    public        => $public,
    category      => $package_category,
  }
}
