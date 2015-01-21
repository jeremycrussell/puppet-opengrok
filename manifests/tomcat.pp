class opengrok::tomcat (
  $gitpkg = $opengrok::gitpkg,
  $svnpkg = $opengrok::svnpkg,
  $ctags = $opengrok::ctags,
  $tomcatpkg = $opengrok::tomcatpkg,
  $tomcatsrvc = $opengrok::tomcatsrvc,
  $tomcatadm = $opengrok::tomcatadm
) {
  require opengrok::files
  package {
    [$tomcatpkg, $tomcatadm] :
      ensure => present;
  }

  file {
    "/var/lib/${tomcatpkg}/webapps/source.war" :
      ensure  => present,
      require => [Package[$tomcatpkg],File["${opengrok::files::bin_path}/source.war"]],
      notify  => Service[$tomcatsrvc],
      source  => "${opengrok::files::bin_path}/source.war";
  }

  service {
    $tomcatsrvc :
      ensure => 'running',
      hasrestart => true,
      hasstatus  => true,
      require    => Package[$tomcatpkg];
  }
}
