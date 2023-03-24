# Puppet Flexera Class
class profile::flexera {
  $build_dir = 'C:\temp\fnms\fnms_agent.zip'
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip')
  $install_flexera = hiera('profile::flexera::install_flexera','false')

  if ($install_flexera == 'true') {
    archive { $build_dir:
      ensure        => present,
      source        => $download_url,
      checksum_type => 'sha256',
      checksum      => '9929bc494433c7843418e4286951df9c055832e6002a8a965402feff85699bac',
      extract       => 'true',
      creates       => "${build_dir}\\fnms",
      extract_path  => "${build_dir}\\fnms",
      cleanup       => 'true',
      before        => Package['FlexNet Inventory Agent'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      source          => "${build_dir}\\fnms\\FlexNet Inventory Agent.msi",
      install_options => [
        '/qn',
        "BOOTSTRAPSCHEDULE='Bootstrap Machine Schedule'",
        "GENERATEINVENTORY='true'",
        "APPLYPOLICY='true'",
        "TRANSFORMS=${build_dir}\\fnms\\InstallFlexNetInvAgent.mst",
      ],
      before          => Service['ndinit'],
    }
    service { 'ndinit':
      ensure => running,
      enable => true,
    }
  }
}
