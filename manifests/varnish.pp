class project::varnish {
    package { "varnish":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    service { "varnish":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package["varnish"],
    }

    file {
        "/etc/varnish/default.vcl":
        ensure  => present,
        require => Package["varnish"],
        source  => "puppet:///modules/project/varnish/default.vcl",
        notify  => Service["varnish"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644';

        "/etc/default/varnish":
        ensure => present,
        require => Package["varnish"],
        source => "puppet:///modules/project/varnish/varnish",
        notify  => Service["varnish"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644';
    }
}