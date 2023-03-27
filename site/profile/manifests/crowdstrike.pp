# @param customer_id
# @param provtoken
# @param falcon_proxy_host
# @param falcon_proxy_port
# @param build_dir
# @param download_url
# @param install_crowdstrike

# Puppet Profile Class Crowdstrike
class profile::crowdstrike (
  String $customer_id  = hiera('profile::crowdstrike::customer_id',undef),
  String $provtoken = hiera('profile::crowdstrike::provtoken',undef),
  Optional[String]  $falcon_proxy_host = hiera('profile::crowdstrike::falcon_proxy_host',undef),
  Optional[String] $falcon_proxy_port = hiera('profile::crowdstrike::falcon_proxy_port',undef),
  String $build_dir = 'C:\temp',
  String $download_url = hiera('profile::crowdstrike::download_url','http://server02.local/repo/CrowdStrike/WindowsSensor.exe'),
  Boolean $install_crowdstrike = hiera('profile::crowdstrike::install_crowdstrike','false')
) {
  if ($install_crowdstrike == 'true') {
    download_file { 'Download CrowdStrike':
      url                   => $download_url,
      destination_directory => $build_dir,
      before                => Packaeg['CrowdStrike Windows Sensor'],
    }

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
