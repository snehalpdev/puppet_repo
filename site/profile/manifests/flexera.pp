# @param build_dir
# @param extract_dir
# @param download_url
# @param install_flexera

# Puppet Flexera Class
class profile::flexera (
  String $build_dir = 'C:\temp\fnms',
  String $extract_dir = 'C:\temp\fnms\extract',
  String $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip'),
  $install_flexera = hiera('profile::flexera::install_flexera','false')
) {
  if ($install_flexera == 'true') {
    file { $build_dir:
      ensure => directory,
      before => Download_file['Download FlexNet Inventory Agent'],
    }

    file { $extract_dir:
      ensure => directory,
      before => Exec['Extract Flexera'],
    }

    exec { 'Extract Flexera':
      command     => "Expand-Archive -Path '${build_dir}\\fnms_agent.zip' -DestinationPath ${extract_dir}",
      provider    => powershell,
      subscribe   => Download_file['Download FlexNet Inventory Agent'],
      refreshonly => true,
      notify      => Package['FlexNet Inventory Agent'],
      before      => Package['FlexNet Inventory Agent'],
    }

    download_file { 'Download FlexNet Inventory Agent':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['Extract Flexera'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      subscribe       => Exec['Extract Flexera'],
      refreshonly     => true,
      source          => "${extract_dir}\\FlexNet Inventory Agent.msi",
      install_options => [
        '/qn',
        'TRANSFORMS=InstallFlexNetInvAgent.mst',
#       'BOOTSTRAPSCHEDULE=Bootstrap Machine Schedule.nds',
        'GENERATEINVENTORY=true',
        'APPLYPOLICY=true',
      ],
      before          => Service['ndinit'],
    }
    service { 'ndinit':
      ensure => running,
      enable => true,
    }
  }
}
