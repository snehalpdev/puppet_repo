# @param build_dir
# @param download_url
# @param install_mcafee

#Puppet Profile class mcafee_agent
class profile::mcafee_agent (
  String $build_dir = 'C:\temp',
  String $download_url = hiera('profile::mcafee_agent::download_url','http://server02.local/repo/mcafee_agent/FramePkg.exe'),
  Boolean $install_mcafee = hiera('profile::mcafee_agent::install_mcafee',false)
) {
  if ($install_mcafee == true) {
    download_file { 'Trellix Agent':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['Trellix Agent'],
    }
    exec { 'Trellix Agent':
      command     => "${build_dir}\\FramePkg.exe /INSTALL=Agent /SILENT",
      subscribe   => Download_file['Trellix Agent'],
      refreshonly => true,
      logoutput   => 'on_failure',
      before      => Service['masvc'],
    }

    service { 'masvc':
      ensure => running,
      enable => true,
    }
  }
}
