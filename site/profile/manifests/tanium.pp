# @param build_dir
# @param extract_dir
# @param target_file
# @param download_url
# @param install_tanium

# Puppet class profile::tanium
class profile::tanium (
  String $build_dir = 'C:\temp\tanium',
  String $extract_dir = 'C:\temp\tanium\extract',
  String $target_file = 'C:\Program Files (x86)\Tanium\Tanium Client\tanium-init.dat',
  String $download_url = hiera('profile::tanium::download_url','http://server02.local/repo/tanium/tanium.zip'),
  Boolean $install_tanium = hiera('profile::tanium::install_tanium',false),
) {
  if ($install_tanium == true) {
    file { $build_dir:
      ensure => directory,
      before => Download_file['Download tanium'],
    }

    file { $extract_dir:
      ensure => directory,
      before => Exec['Extract tanium'],
    }

    download_file { 'Download tanium':
      url                   => $download_url,
      destination_directory => $build_dir,
      notify                => Exec['Extract tanium'],
    }

    exec { 'Extract tanium':
      command     => "Expand-Archive -Path '${build_dir}\\tanium.zip' -DestinationPath ${extract_dir}",
      provider    => powershell,
      subscribe   => Download_file['Download tanium'],
      refreshonly => true,
      notify      => Package['Tanium Client 7.4.5.1225'],
      before      => Package['Tanium Client 7.4.5.1225'],
    }

    package { 'Tanium Client 7.4.5.1225':
      ensure          => 'installed',
      provider        => 'windows',
      subscribe       => Exec['Extract tanium'],
      source          => "${extract_dir}\\SetupClient.exe",
      install_options => [
        '/quiet',
      ],
      notify          => File[$target_file],
      before          => Service['Tanium Client'],
    }

    file { $target_file:
      ensure    => file,
      source    => "${extract_dir}\\tanium-init.dat",
      require   => Package['Tanium Client 7.4.5.1225'],
      subscribe => Package['Tanium Client 7.4.5.1225'],
    }

    service { 'Tanium Client':
      ensure => running,
      enable => true,
    }
  }
}
