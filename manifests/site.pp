#Site.pp
node 'server01.local' {
  include role::windows
}
