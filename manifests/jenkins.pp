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

    exec { "qatools-install":
        command => "pear install pear.phpqatools.org/phpqatools",
        unless => "pear info pear.phpqatools.org/phpqatools",
        require => Exec['pear-auto-discover']
    }

    exec { "jenkins-update-center":
        command => 'wget -O /var/tmp/default.js http://updates.jenkins-ci.org/update-center.json',
        creates => "/var/tmp/default.js",
        require => Package["jenkins"]
    }

    exec { "jenkins-update-center-json":
        command => "sed '1d;$d' /var/tmp/default.js > /var/tmp/default.json",
        creates => "/var/tmp/default.json",
        require => Exec["jenkins-update-center"]
    }

    exec { "jenkins-update-center-update":
        command => 'curl -X POST -H "Accept: application/json" -d @/var/tmp/default.json http://localhost:8080/updateCenter/byId/default/postBack --verbose',
        require => [
                      Exec["jenkins-update-center-json"],
                      Class['apache'],
                      Service['apache']
                   ]
    }

    exec { "jenkins-plugin":
        command => 'mkdir /var/lib/jenkins/plugins',
        creates => "/var/lib/jenkins/plugins",
        group   => 'jenkins',
        require => Exec["jenkins-update-center-update"]
    }

    exec { "jenkins-plugins":
        command => 'jenkins-cli -s http://localhost:8080 install-plugin phing git subversion checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit',
        require => Exec["jenkins-plugin"]
    }

    exec { "jenkins-default-php-template":
        command  => 'mkdir /var/lib/jenkins/jobs/php-template',
        creates  => "/var/lib/jenkins/jobs/php-template",
        group    => 'jenkins',
        require  => Exec["jenkins-plugins"]
    }

    exec { "jenkins-default-php-template-config":
        command  => 'wget https://raw.github.com/sebastianbergmann/php-jenkins-template/master/config.xml',
        cwd      => '/var/lib/jenkins/jobs/php-template',
        require  => Exec["jenkins-default-php-template"]
    }

    exec { "jenkins-restart":
        command => 'jenkins-cli -s http://localhost:8080 safe-restart',
        require => Exec["jenkins-default-php-template-config"]
    }


}