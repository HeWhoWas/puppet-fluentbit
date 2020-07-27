# @summary Filter to append fields or to exclude specific fields.
#
# @param configfile
#  Path to the filter configfile. Naming should be filter_*.conf to make sure
#  it's getting included by the main config.
# @param record
#  Append a key/value pair with key KEY and value VALUE.
# @param remove_key
#  Add a key/value pair with key KEY and value VALUE if KEY does not exist
# @param whitelist_key
#  Remove a key/value pair with key KEY if it exists
# @example
#   fluentbit::filter::record_modifier { 'namevar': }
# @example
#   fluentbit::filter::record_modifier { 'add_hostname':
#     record => { 'hostname' => '${HOSTNAME}' }
#   }
define fluentbit::filter::modify (
  Stdlib::Absolutepath $configfile = "/etc/td-agent-bit/plugins.d/filter_record_modifier_${name}.conf",
  String $match                    = '*',
  Optional[Hash] $record           = undef,
  Optional[Hash] $remove_key       = undef,
  Optional[Hash] $whitelist_key    = undef,
) {
  # create filter_modify.conf
  # TODO: concat for multiple entries
  file { $configfile:
    ensure  => file,
    mode    => '0644',
    content => template('fluentbit/filter/record_modifier.conf.erb'),
    notify  => Class['fluentbit::service'],
    require => Class['fluentbit::install'],
  }
}
