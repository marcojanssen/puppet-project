class project::php5 {

    package { 'php5': ensure   => present }
    package { 'php5-common': ensure   => present, require  => Package["php5"] }
    package { 'php5-curl': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-cli': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-intl': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-imagick': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-gd': ensure   => present, require  => Package["php5-common"] }
    package { 'mcrypt': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-mcrypt': ensure   => present, require  => Package["mcrypt"] }
    package { 'php5-mysql': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-sqlite': ensure   => present, require  => Package["php5-common"] }
    package { 'php5-xcache': ensure   => present, require  => Package["php5-common"] }

    exec { "symlink-mcrypt-apache2":
        command => "ln -sf /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/mcrypt.ini",
        require => Package['php5-mcrypt'],
        creates => "/etc/php5/apache2/conf.d/mcrypt.ini",
        notify  => Service["apache"]
    }

    exec { "symlink-mcrypt-cli":
        command => "ln -sf /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/mcrypt.ini",
        require => Package['php5-mcrypt'],
        creates => "/etc/php5/cli/conf.d/mcrypt.ini",
        notify  => Service["apache"]
    }

    file {
        "/etc/php5/apache2/php.ini":
        ensure  => present,
        require => [
            Package["php5"]
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
            Package["php5"]
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
            Package["php5"]
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
            Package["php5"]
        ],
        source  => "puppet:///modules/project/php5/xcache.ini",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }


}