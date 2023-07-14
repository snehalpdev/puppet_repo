# include windows_splunk::config
# @param target_uri
# @param target_file
class windows_splunk::config (
  String  $target_file           = $windows_splunk::target_file,
  String  $target_uri            = $windows_splunk::target_uri,
) {
  file { $target_file:
    ensure  => file,
    owner   => 'Administrators',
    group   => 'Administrators',
    content => template('windows_splunk/deploymentclient.erb'),
    rights  => [
      { identity => 'Administrators', rights => ['full'] },
      { identity => 'SYSTEM', rights => ['read','execute'] },
      { identity => 'Users', rights => ['read'] },
    ],
    notify  => Class['windows_splunk::service'],
  }
}
