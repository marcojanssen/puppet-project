class project::pdflib {

    file { "/etc/php5/extensions":
        require => [ Package["php5"] ],
        ensure => "directory",
        owner   => 'root',
        group   => 'root'
    }

    file { "/etc/php5/extensions/php_pdflib.so":
        require => [ Package["php5"] ],
        ensure  => present,
        source  => "puppet:///modules/project/pdflib/php_pdflib.so", 
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service["apache"]
    }

    file { "/etc/php5/mods-available/pdflib.ini":
        require => [ Package["php5"] ],
        ensure  => present,
        source  => "puppet:///modules/project/pdflib/pdflib.ini",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        notify  => Service["apache"]
    }

    exec { "symlink-pdflib-apache2":
        command => "ln -sf /etc/php5/mods-available/pdflib.ini /etc/php5/apache2/conf.d/pdflib.ini",
        require => File['/etc/php5/mods-available/pdflib.ini'],
        notify  => Service["apache"]
    }

    exec { "symlink-pdflib-cli":
        command => "ln -sf /etc/php5/mods-available/pdflib.ini /etc/php5/cli/conf.d/pdflib.ini",
        require => File['/etc/php5/mods-available/pdflib.ini'],
        notify  => Service["apache"]
    }
}
