# Puppet Flexera Class
class profile::flexera {
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip')
  $install_flexera = hiera('profile::flexera::install_flexera','false')

  if ($install_flexera == 'true') {
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
      before      => Exec['FlexNet Inventory Agent'],
      notify      => Exec['FlexNet Inventory Agent'],
    }

    download_file { 'Download FlexNet Inventory Agent':
      url                   => $download_url,
      destination_directory => 'C:\temp\fnms',
      notify                => Exec['download-and-extract-zip'],
    }

    exec { 'FlexNet Inventory Agent':
      command     => 'cmd.exe /c C:\temp\fnms\extract\installagent.cmd',
      subscribe   => Exec['download-and-extract-zip'],
      onlyif      => 'if exist C:\temp\fnms\extract\installagent.cmd',
      runas       => 'Administrator',
      refreshonly => true,
      before      => Service['ndinit'],
    }

#   package { 'FlexNet Inventory Agent':
#     ensure          => 'installed',
#     provider        => 'windows',
#     source          => 'C:\\temp\\fnms\\extract\\FlexNet Inventory Agent.msi',
#     install_options => [
#       '/qn',
#       'TRANSFORMS=C:\\temp\\fnms\\extract\\InstallFlexNetInvAgent.mst',
#       'BOOTSTRAPSCHEDULE=C:\\temp\\fnms\\extract\\Bootstrap Machine Schedule.nds',
#       'GENERATEINVENTORY=true',
#       'APPLYPOLICY=true',
#     ],
#     before          => Service['ndinit'],
#   }
    service { 'ndinit':
      ensure => running,
      enable => true,
    }
  }
}
