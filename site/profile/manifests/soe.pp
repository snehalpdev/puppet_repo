class profile::soe (
  # MOTD
  $motd = true,
  # Activation ## KMS activation
  $activate = false,
  # DNS client
  $dnsclient = false,
  # Domain Join
  $domainjoin = false,
  # Windows Firewall
  $firewall = false,
  # Windows Features
  $windowsfeatures = false,
  # Package installer
  $packageinstall = false,
  # Splunk Forwarder
  $splunk_forwarder = false,
  # Timezone
  $timezone = false,
  # Local user management
  $users = false,
  # VMtools
  $vmtools = false,
  # WinRM
  $winrm = false,
  # WSUS client
  $wsusclient = false,
  # Crowdstrike Falcon
  $crowdstrike = false,
  # CIS Hardening
  $cis_hardening = false,
  )
  {

    if $motd == true {
      include windows::motd
    }

  #  if $dnsclient == true {
  #    include windows::dnsclient
  #  }

  #  if $domainjoin == true {
  #    include windows::domain_membership
  #  }

  #  if $windowsfeatures == true {
  #    include windows::windowsfeatures
  #  }

  #  if $packageinstall == true {
  #    include windows::package
  #  }

  #  if $splunk_forwarder == true {
  #    include windows::splunk_forwarder
  #  }

  #  if $timezone == true {
  #    include windows::timezone
  #  }

  #  if $users == true {
  #    include windows::users
  #  }

  #  if $vmtools == true {
  #    include windows::vmtools
  #  }

  #  if $winrm == true {
  #    include windows::winrm
  #  }

  #  if $wsusclient == true {
  #    include windows::wsusclient
  #  }

  # if $crowdstrike == true {
  #   include windows::crowdstrike
  # }

  # if $activate == true {
  #  include windows::activation
  # }

  # if $firewall == true {
  #   include windows::windows_firewall
  # }

  # if $cis_hardening == true {
  #   include windows::cis_windows
  # }
  }
