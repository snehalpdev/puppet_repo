# @param build_dir
# @param logfile
# @param download_url
# @param install_mcafee

#Puppet Profile class mcafee_agent
class profile::mcafee_agent (
  String $build_dir = 'C:\temp',
  String $logfile = 'C:\temp\Install.log',
  String $download_url = hiera('profile::mcafee_agent::download_url','http://server02.local/repo/mcafee_agent/FramePkg.exe'),
  $install_mcafee = hiera('profile::mcafee_agent::install_mcafee','false')
) {
  if ($install_mcafee == 'true') {
    download_file { 'Download Mcafee Agent':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['McAfee Endpoint Agent'],
    }
    exec { 'McAfee Endpoint Agent':
      command   => "${build_dir}\\FramePkg.exe /INSTALL=Agent /SILENT",
#     logoutput => 'on_failure',
      logoutput => $logfile,
      before    => Service['masvc'],
    }

    service { 'masvc':
      ensure => running,
      enable => true,
    }
  }
}
