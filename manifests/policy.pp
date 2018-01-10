# == Class: murano::policy
#
# Configure the murano policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for murano
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
#   (optional) Path to the murano policy.json file
#   Defaults to /etc/murano/policy.json
#
class murano::policy (
  $policies    = {},
  $policy_path = '/etc/murano/policy.json',
) {

  include ::murano::deps
  include ::murano::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::murano::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'murano_config': policy_file => $policy_path }

}
