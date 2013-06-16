class project::jenkins {

    package { "jenkins":
        ensure  => present,
        require => Exec["apt-update"]
    }
}