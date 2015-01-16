
define opengrok::git::repo($git_url) {
  exec {
    "git clone of ${name}" :
      command => "git clone ${git_url} ${name}",
      cwd     => "${opengrok::dirs::base_path}/source",
      path    => ['/bin', '/usr/bin'],
      unless  => "test -d ${opengrok::dirs::base_path}/source/${name}",
      timeout => 0,
      notify  => [
        Service['tomcat7'],
        Exec['opengrok-reindex']],
      require => [
        File[$opengrok::dirs::base_path],
        Package['git-core']];
  }
}
