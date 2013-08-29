class project::phpunit {

    package { "phpunit":
        ensure   => present,
        require  => Exec["apt-update"]
    }
}