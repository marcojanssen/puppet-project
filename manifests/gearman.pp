class project::gearman {

    exec { "gearman-repo":
        command => "add-apt-repository ppa:gearman-developers/ppa",
        before  => Exec['apt-update']
    }

    package { "gearman":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    package { "gearman-server":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    package { "libgearman7":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    package { "libgearman-dev":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    php::pecl::module { "gearman":
        use_package => 'no',
        require => [
            Package['gearman'],
            Package['gearman-server'],
            Package['libgearman7'],
            Package['libgearman-dev'],
            Exec['pear-auto-discover']
        ],
        notify  => Service["apache"]
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