# Puppet profile class
class profile::soe {
  include motd
  include profile::flexera
}
