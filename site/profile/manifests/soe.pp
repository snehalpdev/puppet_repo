Class profile::soe (
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
) {
  if $motd == true {
    include motd
  }
#  if $dnsclient == true {
#    include dnsclient
#  }
#  if $domainjoin == true {
#    include domain_membership
#  }
#  if $windowsfeatures == true {
#    include windowsfeatures
#  }
#  if $packageinstall == true {
#    include package
#  }
#  if $splunk_forwarder == true {
#    include splunk_forwarder
#  }
#  if $timezone == true {
#    include timezone
#  }
#  if $users == true {
#    include users
#  }
#  if $vmtools == true {
#    include vmtools
#  }
#  if $winrm == true {
#    include winrm
#  }
#  if $wsusclient == true {
#    include wsusclient
#  }
# if $crowdstrike == true {
#   include crowdstrike
# }
# if $activate == true {
#  include activation
# }
# if $firewall == true {
#   include windows_firewall
# }
}
