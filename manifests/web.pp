class project::web {

    /*== apache ==*/
    class { "apache":
        require => Exec["apt-update"],
    }

    apache::module { "rewrite": }
    apache::module { "headers": }
    apache::module { "expires": }

    /*== vhost ==*/
    apache::vhost { 'dev.local':
        docroot             => '/var/www',
        server_name         => 'dev.local',
        priority            => '',
        template            => 'apache/virtualhost/vhost.conf.erb',
    }

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
}