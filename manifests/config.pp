# == Class: murano::config
#
# This class is used to manage arbitrary murano configurations.
#
# === Parameters
#
# [*murano_config*]
#   (optional) Allow configuration of arbitrary murano configurations.
#   The value is an hash of murano_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   murano_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class murano::config (
  $murano_config        = {},
) {

  validate_hash($murano_config)

  create_resources('murano_config', $murano_config)
}
