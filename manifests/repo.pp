
define opengrok::repo($repo_url) {
  if $repo_url =~ /git/ {
    opengrok::git::repo { "$name": 
     git_url => "$repo_url" 
    }
  } elsif $repo_url =~ /svn/ {
    opengrok::svn::repo { "$name":
      svn_url => "$repo_url"
    }
  } else {
    warning("repository type not implemented.")
  }
}

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

define opengrok::svn::repo($svn_url) {
  exec {
    "svn checkout of ${name}" :
      command => "svn checkout ${svn_url}",
      cwd     => "${opengrok::dirs::base_path}/source"
      path    => ['/bin', '/usr/bin'],
      unless  => "test -d ${opengrok::dirs::base_path}/source/${name}",
      timeout => 0,
      notify  => [
        Serive['tomcat7'],
        Exec['opengrok-reindex]],
      require => [
        File[$opengrok::dirs::base_path],
        Package['svn']];
  }
}
