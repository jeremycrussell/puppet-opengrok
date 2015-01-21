
define opengrok::repo(
  $repo_url,
  $gitpkg = $opengrok::gitpkg,
  $svnpkg = $opengrok::svnpkg,
  $ctags = $opengrok::ctags,
  $tomcatpkg = $opengrok::tomcatpkg,
  $tomcatsrvc = $opengrok::tomcatsrvc,
  $tomcatadm = $opengrok::tomcatadm
) {
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

define opengrok::git::repo(
  $git_url,
  $gitpkg = $opengrok::gitpkg,
  $svnpkg = $opengrok::svnpkg,
  $ctags = $opengrok::ctags,
  $tomcatpkg = $opengrok::tomcatpkg,
  $tomcatsrvc = $opengrok::tomcatsrvc,
  $tomcatadm = $opengrok::tomcatadm
  ) {
  exec {
    "git clone of ${name}" :
      command => "git clone ${git_url} ${name}",
      cwd     => "${opengrok::dirs::base_path}/source",
      path    => "/bin:/sbin:/usr/bin:/usr/sbin",
      unless  => "test -d ${opengrok::dirs::base_path}/source/${name}",
      timeout => 0,
      notify  => [
        Service[$tomcatsrvc],
        Exec['opengrok-reindex']],
      require => [
        File[$opengrok::dirs::base_path],
        Package[$gitpkg]];
  }
}

define opengrok::svn::repo( 
  $svn_url,
  $gitpkg = $opengrok::gitpkg,
  $svnpkg = $opengrok::svnpkg,
  $ctags = $opengrok::ctags,
  $tomcatpkg = $opengrok::tomcatpkg,
  $tomcatsrvc = $opengrok::tomcatsrvc,
  $tomcatadm = $opengrok::tomcatadm
) {
  exec {
    "svn checkout of ${name}" :
      command => "svn checkout ${svn_url}",
      cwd     => "${opengrok::dirs::base_path}/source",
      path    => "/bin:/sbin:/usr/bin:/usr/sbin",
      unless  => "test -d ${opengrok::dirs::base_path}/source/${name}",
      timeout => 0,
      notify  => [
        Service[$tomcatsrvc],
        Exec['opengrok-reindex']],
      require => [
        File[$opengrok::dirs::base_path],
        Package[$svnpkg]];
  }
}
