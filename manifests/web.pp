class project::web {

    /*== apache ==*/
    class { "apache":
        require => Exec["apt-update"],
    }

    apache::module { "rewrite": }
    apache::module { "headers": }
    apache::module { "expires": }
    apache::module { "proxy": }
    apache::module { "proxy_http": }
    apache::module { "vhost_alias": }

    /*== SSL ==*/
    include apache::ssl

    exec { "default-ssl":
        command => "a2ensite default-ssl",
        require => Class['apache::ssl']
    }

    exec { "www-chown":
        command => "chown vagrant. /var/www",
        require => Class['apache']
    }

    /*== Copies a default vhost for easy vhosting ==*/
    file {
        "/etc/apache2/sites-enabled/000-default":
        ensure  => present,
        require => Package["apache"],
        source  => "puppet:///modules/project/apache/000-default",
        notify  => Service["apache"],
        owner   => 'root',
        group   => 'root',
        mode    => '0644';
    }
}