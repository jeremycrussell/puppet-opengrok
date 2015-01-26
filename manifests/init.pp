class opengrok (
  $repos
) {

  case $operatingsystem {
    centos, redhat: { 
      $gitpkg = "git" 
      $svnpkg = "subversion.${architecture}"
      $ctags = "ctags"
      $tomcatpkg = "tomcat"
      $tomcatsrvc = "tomcat"
      $tomcatadm = "tomcat-admin-webapps"
    }
    debian, ubuntu: { 
      $gitpkg = "git-core" 
      $svnpkg = "svn"
      $ctags = "exuberant-ctags"
      $tomcatpkg = "tomcat7"
      $tomcatsrvc = "tomcat7"
      $tomcatadm = "tomcat7-admin"
    }
    default: { fail("Unrecognized operating system!") }
  }
  
  if ! defined (Package[$ctags, $gitpkg, $svnpkg])
    package {
      [$ctags, $gitpkg, $svnpkg] :
        ensure => present;
    }
  }

  create_resources(opengrok::repo, $repos)

  class {
    'opengrok::dirs' : ;
    'opengrok::files' :
      require => Class['opengrok::dirs'];
    'opengrok::tomcat' :
      require => Class['opengrok::files'];
  }

  exec {
    'opengrok-reindex' :
      refreshonly => true,
      command     => '/var/opengrok/bin/opengrok-indexer',
      path        => ['/usr/bin'],
      timeout     => 0,
      notify      => Service[$tomcatsrvc],
      require     => File['/var/opengrok/bin/opengrok-indexer'];
  }

  cron {
    'update-opengrok-repos' :
      command => '/var/opengrok/bin/opengrok-update',
      user    => root,
      minute  => '10',
  }
}
