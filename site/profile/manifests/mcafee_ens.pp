# @param build_dir
# @param extract_dir
# @param download_url
# @param install_mcafee_ens

#Puppet Profile class mcafee_ens
class profile::mcafee_ens (
  String $build_dir = 'C:\temp\mcafee_ens',
  String $extract_dir = 'C:\temp\mcafee_ens\extract',
  String $download_url = hiera('profile::mcafee_ens::download_url','http://server02.local/repo/mcafee_ens/mcafee_ens.zip'),
  Boolean $install_mcafee_ens = hiera('profile::mcafee_ens::install_mcafee_ens',false)
) {
  if ($install_mcafee_ens == true) {
    file { $build_dir:
      ensure => directory,
      before => Download_file['Download Mcafee ENS'],
    }

    file { $extract_dir:
      ensure => directory,
      before => Exec['Extract Mcafee ENS'],
    }

    exec { 'Extract Mcafee ENS':
      command     => "Expand-Archive -Path '${build_dir}\\mcafee_ens.zip' -DestinationPath ${extract_dir}",
      provider    => powershell,
      subscribe   => Download_file['Download Mcafee ENS'],
      refreshonly => true,
      notify      => Package['McAfee Endpoint Security Platform'],
      before      => Package['McAfee Endpoint Security Platform'],
    }

    download_file { 'Download Mcafee ENS':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['Extract Mcafee ENS'],
    }

    package { 'McAfee Endpoint Security Platform':
      ensure          => 'installed',
      provider        => 'windows',
      subscribe       => Exec['Extract Mcafee ENS'],
      source          => "${extract_dir}\\setupEP.exe",
      install_options => [
        '/qn',
        'ADDLOCAL="tp"',
      ],
      require         => Class['profile::mcafee_agent'],
    }
  }
}
