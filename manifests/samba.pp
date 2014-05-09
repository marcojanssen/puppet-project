class project::samba {

    package { 'samba':
        ensure   => present,
        require  => Exec["apt-update"]
    }

    file { "/etc/samba/smb.conf":
        ensure  => present,
        source  => "puppet:///modules/project/samba/smb.conf",
        require => Package['samba'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644'
    }

    exec { "restart-samba":
        command => "service smbd restart",
        require => File['/etc/samba/smb.conf']
    }
}