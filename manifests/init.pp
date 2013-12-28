class project {

    include augeas
    include project::apt

    file {
      "/home/vagrant/.bashrc":
      ensure  => present,
      require => Package["varnish"],
      source  => "puppet:///modules/project/.bashrc",
      notify  => Service["varnish"],
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

      "/home/vagrant/.vimrc":
      ensure => present,
      require => Package["varnish"],
      source => "puppet:///modules/project/.vimrc",
      notify  => Service["varnish"],
      owner   => 'root',
      group   => 'root',
      mode    => '0644';
    }
}