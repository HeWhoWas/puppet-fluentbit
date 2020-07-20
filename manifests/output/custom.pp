# @summary Manage the configuration of a custom output plugin.
#
# The http output plugin allows to flush your records into a HTTP endpoint.
# This type manages the configuration for it.
#
# @param configfile
#  Path to the output configfile. Naming should be output_*.conf to make sure
#  it's getting included by the main config.
#
# @param match
#  Tag to route the output.
#
# @param retry_limit
#   Number of retries if upstream refuses the records.
#   *false* will disable retries, *true* will cause it to retry once.
#   All other values are passed on verbatim.
#
# @param output_config
#   A hash that is inserted into the config file as-is. All configuration
#   options for this output must be provided here.
#
# @example
#   fluentbit::output::custom { 'my-custom-plugin':
#     retry_limit         => false,
#     output_config       => {
#       'alias'           => 'custom_output',
#       'TimestampFormat' => '2006-01-02T15-04-05' 
#     }
#   }
define fluentbit::output::custom (
  String $type,
  Stdlib::Absolutepath $configfile    = "/etc/td-agent-bit/plugins.d/output_http_${name}.conf",
  Variant[Undef, Boolean, Integer[1]]
    $retry_limit                      = undef,
  Optional[String[1]] $match          = undef,
  Hash $output_config                 = {}
) {

  file { $configfile:
    ensure  => file,
    mode    => $fluentbit::config_file_mode,
    content => template('fluentbit/output/custom.conf.erb'),
    notify  => Class['fluentbit::service'],
  }
}
