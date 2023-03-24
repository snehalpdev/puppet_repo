Class profile::mcafee_agent (
  $build_dir = 'C:\temp\Mcafee',
  $logfile = 'C:\temp\Mcafee\Install.log',
  $download_url = hiera('profile::mcafee_agent::download_url','http://server02.local/repo/mcafee/mcafee.zip'),
  $install_mcafee = hiera('profile::mcafee_agent::install_mcafee','false')
) {
  if ($install_mcafee == 'true') {
    # Download and extract the package
    archive { $build_dir:
      ensure        => present,
      source        => $download_url,
      checksum_type => 'sha256',
      checksum      => 'ab1c23d4e5f67a89b0c1d2e3f4a56789b0c1d2e3f4a56789b0c1d2e3f4a56789',
      before        => exec['McAfee Endpoint Agent'],
    }

    # Install and configure McAfee Endpoint Agent
    exec { 'McAfee Endpoint Agent':
      command   => "${build_dir}\\Endpoint_Agent_Standalone\\FramePkg.exe /INSTALL=UPDATER /SILENT",
      logoutput => 'on_failure',
      log       => $logfile,
      before    => service['masvc'],
    }

    service { 'masvc':
      ensure => running,
      enable => true,
    }
  }
}
