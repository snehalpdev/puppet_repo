# @param build_dir
# @param extract_dir
# @param download_url
# @param install_mcafee_ens

#Puppet Profile class mcafee_ens
class profile::mcafee_ens (
  String $build_dir = 'C:\temp\mcafee_ens',
  String $extract_dir = 'C:\temp\mcafee_ens\extract',
  String $download_url = hiera('profile::mcafee_ens::download_url','http://server02.local/repo/mcafee_ens/mcafee_ens.zip'),
  $install_mcafee_ens = hiera('profile::mcafee_ens::install_mcafee_ens','false')
) {
  if ($install_mcafee_ens == 'true') {
    file { $build_dir:
      ensure => directory,
      before => Download_file['Download Mcafee Endpoint Network Security'],
    }

    file { $extract_dir:
      ensure => directory,
      before => Exec['download-and-extract-zip'],
    }

    exec { 'download-and-extract-zip':
      command     => "Expand-Archive -Path '${build_dir}\\mcafee_ens.zip' -DestinationPath ${extract_dir}",
      provider    => powershell,
      subscribe   => Download_file['Download Mcafee Endpoint Network Security'],
      refreshonly => true,
      before      => Exec['Mcafee Endpoint Network Security'],
    }

    download_file { 'Download Mcafee Endpoint Network Security':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['download-and-extract-zip'],
    }

    exec { 'McAfee Endpoint Network Security':
      command   => "${extract_dir}\\setupEP.exe ADDLOCAL='tp' /qn",
      logoutput => 'on_failure',
      require   => Class['profile::mcafee_agent'],
    }
  }
}
