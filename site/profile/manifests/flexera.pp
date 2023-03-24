# Puppet Flexera Class
class profile::flexera {
  $zip_file = 'C:\temp\fnms_agent.zip'
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip')
  $install_flexera = hiera('profile::flexera::install_flexera','false')

  if ($install_flexera == 'true') {
    archive { $zip_file:
      ensure        => present,
      source        => $download_url,
      checksum_type => 'sha256',
      checksum      => '9929bc494433c7843418e4286951df9c055832e6002a8a965402feff85699bac',
      extract       => 'true',
      extract_path  => 'C:\\temp\\build',
      creates       => 'C:\\temp\\build\\installed.txt',
      cleanup       => 'true',
      before        => Package['FlexNet Inventory Agent'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      source          => 'C:\\temp\\build\\FlexNet Inventory Agent.msi',
      install_options => [
        '/qn',
        'TRANSFORMS=C:\\temp\\build\\InstallFlexNetInvAgent.mst',
      ],
      before          => Service['ndinit'],
    }
    service { 'ndinit':
      ensure => running,
      enable => true,
    }
  }
}
