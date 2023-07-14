# Puppet profile class
class profile::soe {
  include motd
  include profile::flexera
  include profile::mcafee_agent
  include profile::mcafee_ens
  include windows_splunk
}
