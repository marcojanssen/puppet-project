class project::mongodb {

    exec { "mongodb-apt-get-key":
        command => "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10",
        before  => Exec['apt-update']
    }

    exec { "mongodb-apt-get-sources":
        command => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list",
        creates => '/etc/apt/sources.list.d/mongodb.list',
        require => Exec["mongodb-apt-get-key"],
        before  => Exec['apt-update']
    }

    package { "mongodb-org":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    package { "php5-mongo":
        ensure   => present,
        require  => [
            Exec["apt-update"],
            Package["php"],
            Package["mongodb-org"]
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