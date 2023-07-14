# include windows_splunk::config
# @param target_uri
# @param target_file
class windows_splunk::config (
  String  $target_file           = $windows_splunk::target_file,
  String  $target_uri            = $windows_splunk::target_uri,
) {
  file { $target_file:
    ensure  => file,
    content => template('windows_splunk/deploymentclient.erb'),
    notify  => Class['windows_splunk::service'],
  }
}
