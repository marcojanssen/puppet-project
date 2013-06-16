class project::jenkins {

    package { "jenkins":
        ensure  => present,
        require => Exec["apt-update"]
    }

    service { "jenkins":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package["jenkins"]
    }

    exec { "jenkins-plugin-cloverphp":
        command => 'wget http://updates.jenkins-ci.org/latest/cloverphp.hpi -O /var/lib/jenkins/plugins',
        require => Package["jenkins"],
        notify => Service['jenkins']
    }
}