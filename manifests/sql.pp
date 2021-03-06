class project::sql {

    class { "mysql":
        root_password => "root",
        require       => Exec["apt-update"],
    }

    package { "sqlite3":
        ensure => present,
        require       => Exec["apt-update"]
    }
}