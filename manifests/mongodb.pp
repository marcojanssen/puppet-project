class project::mongodb {

    exec { "mongodb-apt-get-key":
        command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
        before  => Exec['apt-update']
    }

    exec { "mongodb-apt-get-sources":
        command => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list",
        creates => '/etc/apt/sources.list.d/10gen.list',
        require => Exec["mongodb-apt-get-key"],
        before  => Exec['apt-update']
    }

    package { "mongodb":
        ensure   => present,
        require  => Exec["apt-update"]
    }

    php::pecl::module { "mongo":
        require => Package['mongodb']
    }

    file {
        "/etc/php5/conf.d/mongo.ini":
        ensure  => present,
        require => [
                      Package["mongodb"],
                      Package["apache"]
                   ],
        source  => "puppet:///modules/project/mongodb/php.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
}