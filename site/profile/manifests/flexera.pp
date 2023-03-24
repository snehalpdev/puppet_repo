Class profile::flexera (
  $build_dir = 'C:\temp\Flexera',
  $download_url = hiera('profile::flexera::download_url','http://server02.local/repo/fnms/fnms_agent.zip'),
  $install_flexera = hiera('profile::flexera::install_flexera','false'),
) {
  if ($install_flexera == 'true') {
    # Download and extract the package
    archive { $build_dir:
      ensure        => present,
      source        => $download_url,
      checksum_type => 'sha256',
      checksum      => 'ab1c23d4e5f67a89b0c1d2e3f4a56789b0c1d2e3f4a56789b0c1d2e3f4a56789',
      before        => package['FlexNet Inventory Agent'],
    }

    package { 'FlexNet Inventory Agent':
      ensure          => 'installed',
      provider        => 'windows',
      source          => "${build_dir}\\FlexNet Inventory Agent.msi",
      install_options => [
        '/qn',
        "BOOTSTRAPSCHEDULE='Bootstrap Machine Schedule'",
        "GENERATEINVENTORY='true'",
        "APPLYPOLICY='true'",
        "TRANSFORMS=${build_dir}\\InstallFlexNetInvAgent.mst",
      ],
      before          => service['ndinit'],
    }

    service { 'ndinit':
      ensure => running,
      enable => true,
    }
  }
}
