#Puppet role
class role::windows {
  include profile::soe
  include profile::falcon
}
