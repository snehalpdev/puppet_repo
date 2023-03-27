# Puppet Flexera Class
class profile::flexera {
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip')
  $install_flexera = hiera('profile::flexera::install_flexera','false')
  $flexnet_installed = reg_query('HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{F56247D8-9D8D-4180-BD6D-44485EC1A3C0}', { 'type' => 'exists' })

  if ($install_flexera == 'true' -AND ($flexnet_installed == 'false')) {
    file { 'C:\temp\fnms':
      ensure => directory,
      before => Download_file['Download FlexNet Inventory Agent'],
    }

    file { 'C:\temp\fnms\extract':
      ensure => directory,
      before => Exec['download-and-extract-zip'],
    }

    exec { 'download-and-extract-zip':
      command     => 'Expand-Archive -Path C:\temp\fnms\fnms_agent.zip -DestinationPath C:\temp\fnms\extract',
      provider    => powershell,
      subscribe   => Download_file['Download FlexNet Inventory Agent'],
      refreshonly => true,
      before      => Package['FlexNet Inventory Agent'],
      notify      => Package['FlexNet Inventory Agent'],
    }

    download_file { 'Download FlexNet Inventory Agent':
      url                   => $download_url,
      destination_directory => 'C:\temp\fnms',
      notify                => Exec['download-and-extract-zip'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      subscribe       => Exec['download-and-extract-zip'],
      source          => 'C:\\temp\\fnms\\extract\\FlexNet Inventory Agent.msi',
      install_options => [
        '/qn',
        'TRANSFORMS=InstallFlexNetInvAgent.mst',
#       'BOOTSTRAPSCHEDULE=Bootstrap Machine Schedule',
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
