Class profile::crowdstrike (
  $customer_id  = hiera('profile::crowdstrike::customer_id',undef),
  $provtoken = hiera('profile::crowdstrike::provtoken',undef),
  $falcon_proxy_host = hiera('profile::crowdstrike::falcon_proxy_host',undef),
  $falcon_proxy_port = hiera('profile::crowdstrike::falcon_proxy_port',undef),
  $build_dir = 'C:\temp\CrowdStrike',
  $download_url = hiera('profile::crowdstrike::download_url','http://server02.local/repo/CrowdStrike/crowdstrike.zip'),
  $install_crowdstrike = hiera('profile::crowdstrike::install_crowdstrike','false')
) {
  if ($install_crowdstrike == 'true') {
    # Download and extract the package
    archive { $build_dir:
      ensure        => present,
      source        => $download_url,
      checksum_type => 'sha256',
      checksum      => 'ab1c23d4e5f67a89b0c1d2e3f4a56789b0c1d2e3f4a56789b0c1d2e3f4a56789',
      before        => package['CrowdStrike Windows Sensor'],
    }

    # Install and configure Crowdstrike
    package { 'CrowdStrike Windows Sensor':
      ensure          => installed,
      source          => "${build_dir}\\WindowsSensor.exe",
      install_options => [
        '/install',
        '/quiet',
        '/norestart',
        "CID=${customer_id}",
        "ProvToken=${provtoken}",
        'ProvWaitTime=3600000',
        "APP_PROXYNAME=${falcon_proxy_host}",
        "APP_PROXYPORT=${falcon_proxy_port}",
      ],
      provider        => windows,
      before          => service['CSFalconService'],
    }

    service { 'CSFalconService':
      ensure => running,
      enable => true,
    }
  }
}
