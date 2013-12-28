class project::adminer {

    exec { "mkdir-adminer":
        command => "mkdir -p /var/www/adminer/web",
        path    => ['/bin'],
        unless  => "/usr/bin/test -d /var/www/adminer/web"
    }

    exec { "download-adminer":
        command => "wget http://downloads.sourceforge.net/adminer/adminer-3.7.1.php",
        cwd     => '/var/www/adminer/web',
        path    => ['/usr/bin', '/usr/sbin'],
        require => Exec['mkdir-adminer'],
        unless  => "/usr/bin/test -f /var/www/adminer/web/index.php"
    }

    exec { "rename-adminer":
        command => "mv adminer-3.7.1.php index.php",
        cwd     => '/var/www/adminer/web',
        path    => ['/bin'],
        require => Exec['download-adminer'],
        unless  => "/usr/bin/test -f /var/www/adminer/web/index.php"
    }
}