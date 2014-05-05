class project::pdflib {

	file { "/etc/php5/extensions":
		require => [ Package["php"] ],
		ensure => "directory",
		owner   => 'root',
        group   => 'root'
	}

    file { "/etc/php5/extensions/php_pdflib.so":
		require => [ Package["php"] ],
        ensure  => present,
        source  => "puppet:///modules/project/pdflib/php_pdflib.so", 
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

	file { "/etc/php5/mods-available/pdflib.ini":
		require => [ Package["php"] ],
        ensure  => present,
        source  => "puppet:///modules/project/pdflib/pdflib.ini", 
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }
	
	file { '/etc/php5/conf.d/pdflib.ini':
		require => [ Package["php"] ],
		ensure => 'link',
		target => '/etc/php5/mods-available/pdflib.ini'
	}
	
    exec { "restart-apache":
		require => [ Package["php"] ],
        command => "sudo service apache2 restart"
    }
}