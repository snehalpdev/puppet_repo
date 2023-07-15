# @param build_dir
# @param extract_dir
# @param download_url
# @param install_splunk
# @param target_dir

# include windows_splunk::install
class windows_splunk::install (
  String $build_dir = $windows_splunk::build_dir,
  String $extract_dir = $windows_splunk::extract_dir,
  String $target_dir = $windows_splunk::target_dir,
  String $download_url = $windows_splunk::download_url,
  Boolean $install_splunk = $windows_splunk::install_splunk,
) {
  if ($install_splunk == true) {
    file { $build_dir:
      ensure => directory,
      before => Download_file['Download UniversalForwarder'],
    }

    file { $extract_dir:
      ensure => directory,
      before => Exec['Extract UniversalForwarder'],
    }

    download_file { 'Download UniversalForwarder':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['Extract UniversalForwarder'],
    }

    exec { 'Extract UniversalForwarder':
      command     => "Expand-Archive -Path '${build_dir}\\splunk.zip' -DestinationPath ${extract_dir}",
      provider    => powershell,
      subscribe   => Download_file['Download UniversalForwarder'],
      refreshonly => true,
      notify      => Package['UniversalForwarder'],
      before      => Package['UniversalForwarder'],
    }

    package { 'UniversalForwarder':
      ensure          => 'installed',
      provider        => 'windows',
      subscribe       => Exec['Extract UniversalForwarder'],
      source          => "${extract_dir}\\splunkforwarder-8.2.3-cd0848707637-x64-release.msi",
      install_options => [
        '/quiet',
        'AGREETOLICENSE=yes',
        'LAUNCHSPLUNK=0',
      ],
      notify          => File[$target_dir],
      before          => Class['windows_splunk::service'],
    }

    file { $target_dir:
      ensure    => directory,
      source    => "${extract_dir}\\deploymentclient",
      recurse   => true,
      replace   => true,
      require   => Package['UniversalForwarder'],
      subscribe => Package['UniversalForwarder'],
      before    => Class['windows_splunk::config'],
    }
  }
}
