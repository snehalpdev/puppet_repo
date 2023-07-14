# @param target_file
# @param target_uri
# @param service_name
# @param build_dir
# @param extract_dir
# @param download_url
# @param target_dir
# @param install_splunk

# include splunk
class windows_splunk (
  # windows_splunk::config
  String  $target_file           = 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deploymentclient\local\deploymentclient.conf',
  String  $target_uri            = 'server.example.com',

  # windows_splunk::service
  String  $service_name          = 'SplunkForwarder',

  # windows_splunk::install
  String $build_dir = 'C:\temp\splunk',
  String $extract_dir = 'C:\temp\splunk\extract',
  String $download_url = hiera('windows_splunk::install::download_url','http://server02.local/repo/splunk/splunk.zip'),
  String $target_dir = 'C:\Program Files\SplunkUniversalForwarder\etc\apps\deploymentclient',
  Boolean $install_splunk = hiera('windows_splunk::install::install_splunk',false)

) {
  include windows_splunk::install
  include windows_splunk::config
  include windows_splunk::service
}
