class project::gearman {

    package { "gearman":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    php::pecl::module { "gearman":
        use_package => 'no',
        require => [
          Package['gearman'],
          Exec['pear-auto-discover']
        ]

    }

    file {
        "/etc/php5/conf.d/gearman.ini":
        ensure  => present,
        require => [
            Package["gearman"],
            Package["apache"]
        ],
        source  => "puppet:///modules/project/gearman/php.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
}