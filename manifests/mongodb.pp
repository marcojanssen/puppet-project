class project::mongodb {

    exec { "mongodb-apt-get-key":
        command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
        before  => Exec['apt-update']
    }

    exec { "mongodb-apt-get-sources":
        command => "echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list",
        creates => '/etc/apt/sources.list.d/mongodb.list',
        require => Exec["mongodb-apt-get-key"],
        before  => Exec['apt-update']
    }

    package { "mongodb-10gen":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    exec { "php-mongo-driver":
        command => "pecl install mongo",
        require => [
            Package['mongodb-10gen'],
            Exec['pear-auto-discover']
        ]
    }

    file {
        "/etc/php5/conf.d/mongo.ini":
        ensure  => present,
        require => [
                      Package["mongodb-10gen"],
                      Package["apache"]
                   ],
        source  => "puppet:///modules/project/mongodb/php.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
}