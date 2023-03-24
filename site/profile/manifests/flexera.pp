# Puppet Flexera Class
class profile::flexera {
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip')
  $install_flexera = hiera('profile::flexera::install_flexera','false')

  if ($install_flexera == 'true') {
    directory { 'C:\temp\fnms':
      ensure   => directory,
      provider => powershell,
    }

    exec { 'download-and-extract-zip':
      command     => 'Expand-Archive -Path C:\temp\fnms_agent.zip -DestinationPath C:\temp\fnms',
      provider    => powershell,
      subscribe   => Download_file['Download FlexNet Inventory Agent'],
      refreshonly => true,
      before      => Package['FlexNet Inventory Agent'],
    }

    download_file { 'Download FlexNet Inventory Agent':
      url                   => $download_url,
      destination_directory => 'C:\temp',
      notify                => Exec['download-and-extract-zip'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      source          => 'C:\\temp\\fnms\\FlexNet Inventory Agent.msi',
      install_options => [
        '/qn',
        'TRANSFORMS=C:\\temp\\fnms\\InstallFlexNetInvAgent.mst',
        'BOOTSTRAPSCHEDULE=C:\\temp\\fnms\\Bootstrap Machine Schedule.nds',
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
