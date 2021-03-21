# == Class: murano::policy
#
# Configure the murano policies
#
# === Parameters
#
# [*enforce_scope*]
#  (Optional) Whether or not to enforce scope when evaluating policies.
#  Defaults to $::os_service_default.
#
# [*policies*]
#   (Optional) Set of policies to configure for murano
#   Example :
#     {
#       'murano-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'murano-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the murano policy.yaml file
#   Defaults to /etc/murano/policy.yaml
#
class murano::policy (
  $enforce_scope = $::os_service_default,
  $policies      = {},
  $policy_path   = '/etc/murano/policy.yaml',
) {

  include murano::deps
  include murano::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::murano::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'murano_config':
    enforce_scope => $enforce_scope,
    policy_file   => $policy_path
  }

}
