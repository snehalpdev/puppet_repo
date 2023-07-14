# include windows_splunk::service
class windows_splunk::service {
  service { $windows_splunk::service_name:
    ensure  => running,
    enable  => true,
    require => Class['windows_splunk::config'],
  }
}
