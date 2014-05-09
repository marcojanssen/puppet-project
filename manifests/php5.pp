class project::php5 {

    class { 'php':
        require => Exec["apt-update"],
        augeas => true
    }

    php::module { "common": }
    php::module { "cli": }
    php::module { "intl": }
    php::module { "imagick": }
    php::module { "gd": }
    php::module { "mcrypt": }
    php::module { "curl": }
    php::module { "xdebug": }
    php::module { "mysql": }
    php::module { "sqlite": }
    php::module { "xcache": }

    file {
        "/etc/php5/apache2/php.ini":
        ensure  => present,
        require => [
            Package["php"]
        ],
        source  => "puppet:///modules/project/php5/php.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

    file {
        "/etc/php5/cli/php.ini":
        ensure  => present,
        require => [
            Package["php"]
        ],
        source  => "puppet:///modules/project/php5/php.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

    file {
        "/etc/php5/mods-available/xdebug.ini":
        ensure  => present,
        require => [
            Package["php"]
        ],
        source  => "puppet:///modules/project/php5/xdebug.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

    file {
        "/etc/php5/mods-available/xcache.ini":
        ensure  => present,
        require => [
            Package["php"]
        ],
        source  => "puppet:///modules/project/php5/xcache.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }


}