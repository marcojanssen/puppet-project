class project::pear {

    package { 'php-pear':
        ensure   => present,
        require  => Package["php"]
    }

    package { 'php5-dev':
        ensure   => present,
        require  => Package["php"]
    }

    exec { "pear-upgrade":
        command => "pear upgrade",
        require => Class['php::pear'],
    }

    exec { "pear-auto-discover":
        command => "pear config-set auto_discover 1 system",
        unless => "pear config-get auto_discover system | grep 1",
        require => Exec['pear-upgrade'],
    }
}