class opengrok::files (
  $version="0.12.1",
  $url="http://java.net/projects/opengrok/downloads/download/",
) {
  $bin_path = '/var/opengrok/bin'

  $folder="opengrok-${version}"
  $tarball="${folder}.tar.gz"
  $download_url="${url}/${tarball}"

  exec {
    'download opengrok':
      command => "/usr/bin/wget ${download_url}",
      cwd     => $bin_path,
      creates => "${bin_path}/${tarball}",
      require => File[$bin_path];
  }

  exec {
    'untar opengrok':
      command     => "/bin/tar xzf ${tarball}",
      refreshonly => true,
      cwd         => $bin_path,
      creates     => "${bin_path}/${folder}",
      subscribe   => Exec['download opengrok'],
  }

  file {
    "${bin_path}/OpenGrok" :
      ensure => link,
      mode   => '0555',
      target => "${bin_path}/${folder}/bin/OpenGrok";

    "${bin_path}/source.war" :
      ensure => link,
      target => "${bin_path}/${folder}/lib/source.war";

    "${bin_path}/opengrok.jar" :
      ensure => link,
      target => "${bin_path}/${folder}/lib/opengrok.jar";

    "${bin_path}/opengrok-indexer" :
      ensure => present,
      mode   => '0555',
      source => 'puppet:///modules/opengrok/bin/opengrok-indexer';

    "${bin_path}/opengrok-update" :
      ensure => present,
      mode   => '0555',
      source => 'puppet:///modules/opengrok/bin/opengrok-update';

    "${bin_path}/lib":
      ensure => link,
      target => "${bin_path}/${folder}/lib/lib";

  }
}
