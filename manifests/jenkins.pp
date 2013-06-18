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

    exec { "jenkins-plugins-dir":
        command => 'mkdir /var/lib/jenkins/plugins',
        creates => "/var/lib/jenkins/plugins",
        group   => 'jenkins',
        user     => "jenkins",
        require => [
            Package["jenkins"],
            Package["jenkins-cli"]
        ]
    }

    exec { "jenkins-plugins-update-step1":
        command => 'mkdir /var/lib/jenkins/updates',
        creates => "/var/lib/jenkins/updates",
        require => [
            Package["jenkins"],
            Package["jenkins-cli"],
            Exec["jenkins-plugins-dir"]
        ]
    }

    exec { "jenkins-plugins-update-step2":
        command => "wget -O default.js http://updates.jenkins-ci.org/update-center.json",
        cwd     => "/var/lib/jenkins/updates",
        require => Exec["jenkins-plugins-update-step1"]
    }

    exec { "jenkins-plugins-update-step3":
        command => "sed '1d;$d' default.js > default.json",
        creates => "/var/lib/jenkins/updates/default.json",
        cwd     => "/var/lib/jenkins/updates",
        require => Exec["jenkins-plugins-update-step2"]
    }

    exec { "jenkins-plugins-update-step4":
        command => 'chown -R jenkins:nogroup /var/lib/jenkins/updates',
        require => Exec["jenkins-plugins-update-step3"]
    }

    exec { "jenkins-plugins-update-step5":
        command => 'service jenkins restart',
        require => Exec["jenkins-plugins-update-step4"]
    }

    exec { "jenkins-plugins-install":
        command => 'jenkins-cli -s http://localhost:8080 install-plugin phing git subversion checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit',
        require => Exec["jenkins-plugins-update-step5"]
    }

    exec { "jenkins-restart":
        command => 'jenkins-cli -s http://localhost:8080 safe-restart',
        require => Exec["jenkins-plugins-install"]
    }


}