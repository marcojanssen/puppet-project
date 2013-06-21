class project::jenkins {

    exec { "jenkins-apt-get-key":
        command => "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -",
        before  => Exec['apt-update']
    }

    exec { "jenkins-apt-get-sources":
        command => "sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'",
        creates => '/etc/apt/sources.list.d/jenkins.list',
        require => Exec["jenkins-apt-get-key"],
        before  => Exec['apt-update']
    }

    package { "jenkins":
        ensure  => present,
        require => Exec["apt-update"]
    }

    package { "jenkins-cli":
        ensure  => present,
        require => Exec["apt-update"]
    }

    service { "jenkins":
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package["jenkins"]
    }

    exec { "qatools-install":
        command => "pear install pear.phpqatools.org/phpqatools",
        unless => "pear info pear.phpqatools.org/phpqatools",
        require => Exec['pear-auto-discover']
    }

    project::jenkins::plugin {
        "git" : ;
    }

    project::jenkins::plugin {
        "phing" : ;
    }

    project::jenkins::plugin {
        "subversion" : ;
    }

    project::jenkins::plugin {
        "checkstyle" : ;
    }

    project::jenkins::plugin {
        "cloverphp" : ;
    }

    project::jenkins::plugin {
        "dry" : ;
    }

    project::jenkins::plugin {
        "htmlpublisher" : ;
    }

    project::jenkins::plugin {
        "jdepend" : ;
    }

    project::jenkins::plugin {
        "plot" : ;
    }

    project::jenkins::plugin {
        "pmd" : ;
    }

    project::jenkins::plugin {
        "violations" : ;
    }

    project::jenkins::plugin {
        "xunit" : ;
    }

}